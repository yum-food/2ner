bl_info = {
    "name": "Bake Vertex to Target Vector",
    "blender": (3, 0, 0),
    "category": "Mesh",
    "version": (2, 3, 0),
    "author": "yum_food",
    "description": "Bake vertex vectors with automatic center and scale calculation in Edit Mode, with submesh deduplication"
}

import bpy
import mathutils
import bmesh
import math
from bpy.props import BoolProperty, FloatProperty, IntProperty
from bpy.types import Panel, Operator


class MESH_OT_select_all_linked_submeshes(Operator):
    bl_idname = "mesh.select_all_linked_submeshes"
    bl_label = "Select All Linked Submeshes"
    bl_description = "Select all vertices in any submesh that has at least one vertex selected"
    bl_options = {'REGISTER', 'UNDO'}

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj is not None and
                obj.type == 'MESH' and
                context.mode == 'EDIT_MESH')

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        # Switch to object mode for reliable selection updates
        bpy.ops.object.mode_set(mode='OBJECT')

        # Get currently selected vertices
        initially_selected = set()
        for v in mesh.vertices:
            if v.select:
                initially_selected.add(v.index)

        if not initially_selected:
            self.report({'WARNING'}, "No vertices selected")
            bpy.ops.object.mode_set(mode='EDIT')
            return {'CANCELLED'}

        # Build adjacency from edges
        adjacency = {i: set() for i in range(len(mesh.vertices))}
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            adjacency[v0].add(v1)
            adjacency[v1].add(v0)

        # Find all islands
        all_indices = set(range(len(mesh.vertices)))
        islands = []
        visited = set()

        for start_idx in all_indices:
            if start_idx in visited:
                continue

            island = set()
            queue = [start_idx]

            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue

                visited.add(current)
                island.add(current)

                for neighbor in adjacency[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            islands.append(island)

        # Select vertices in islands that have any selected vertex
        expanded_count = 0
        affected_islands = 0

        for island in islands:
            if island & initially_selected:  # If island has any selected vertices
                new_selections = island - initially_selected
                expanded_count += len(new_selections)
                if new_selections:
                    affected_islands += 1
                # Select all vertices in this island
                for idx in island:
                    mesh.vertices[idx].select = True

        # Select edges where both vertices are selected
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if mesh.vertices[v0].select and mesh.vertices[v1].select:
                edge.select = True

        # Select faces where all vertices are selected
        for face in mesh.polygons:
            all_verts_selected = all(mesh.vertices[v].select for v in face.vertices)
            if all_verts_selected:
                face.select = True

        # Return to edit mode
        bpy.ops.object.mode_set(mode='EDIT')

        self.report({'INFO'}, f"Expanded selection in {affected_islands} submeshes ({expanded_count} new vertices)")
        return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "contiguous_mode")


class MESH_OT_select_linked_across_boundaries(Operator):
    bl_idname = "mesh.select_linked_across_boundaries"
    bl_label = "Select Linked (Cross Boundaries)"
    bl_description = "Select linked vertices, crossing submesh boundaries where vertices share locations"
    bl_options = {'REGISTER', 'UNDO'}

    epsilon: FloatProperty(
        name="Location Tolerance",
        description="Maximum distance for vertices to be considered at the same location",
        default=0.0001,
        min=0.0,
        max=1.0,
        precision=6,
        subtype='DISTANCE'
    )

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj is not None and
                obj.type == 'MESH' and
                context.mode == 'EDIT_MESH')

    def build_position_map(self, mesh, epsilon):
        """Build a map of vertices that share the same position within epsilon"""
        # Use integer hashing for much faster performance
        if epsilon > 0:
            scale = min(1.0 / epsilon, 1e7)  # Cap scale to prevent overflow
        else:
            scale = 1e7  # Large scale for exact matching

        position_map = {}

        # Group vertices by their quantized positions
        for v in mesh.vertices:
            # Quantize to integer grid
            key = (
                int(v.co.x * scale),
                int(v.co.y * scale),
                int(v.co.z * scale)
            )

            if key not in position_map:
                position_map[key] = []
            position_map[key].append(v.index)

        # Create adjacency only for vertices we'll actually use
        # This avoids creating empty sets for all vertices
        position_adjacency = {}

        for vertices_at_pos in position_map.values():
            if len(vertices_at_pos) > 1:
                # For small groups, connect all to all
                if len(vertices_at_pos) <= 10:
                    for i in range(len(vertices_at_pos)):
                        v1 = vertices_at_pos[i]
                        if v1 not in position_adjacency:
                            position_adjacency[v1] = set()
                        for j in range(i + 1, len(vertices_at_pos)):
                            v2 = vertices_at_pos[j]
                            if v2 not in position_adjacency:
                                position_adjacency[v2] = set()
                            position_adjacency[v1].add(v2)
                            position_adjacency[v2].add(v1)
                else:
                    # For large groups, create a hub vertex to avoid O(n²) connections
                    hub = vertices_at_pos[0]
                    if hub not in position_adjacency:
                        position_adjacency[hub] = set()
                    for i in range(1, len(vertices_at_pos)):
                        v = vertices_at_pos[i]
                        if v not in position_adjacency:
                            position_adjacency[v] = set()
                        position_adjacency[hub].add(v)
                        position_adjacency[v].add(hub)

        return position_adjacency

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        # Switch to object mode
        bpy.ops.object.mode_set(mode='OBJECT')

        # Get initially selected vertices
        initially_selected = {v.index for v in mesh.vertices if v.select}

        if not initially_selected:
            self.report({'WARNING'}, "No vertices selected")
            bpy.ops.object.mode_set(mode='EDIT')
            return {'CANCELLED'}

        # Build edge adjacency only for vertices we might visit
        edge_adjacency = {}
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if v0 not in edge_adjacency:
                edge_adjacency[v0] = set()
            if v1 not in edge_adjacency:
                edge_adjacency[v1] = set()
            edge_adjacency[v0].add(v1)
            edge_adjacency[v1].add(v0)

        # Build position adjacency
        position_adjacency = self.build_position_map(mesh, self.epsilon)

        # Function to get combined neighbors efficiently
        def get_neighbors(vertex_idx):
            neighbors = set()
            if vertex_idx in edge_adjacency:
                neighbors.update(edge_adjacency[vertex_idx])
            if vertex_idx in position_adjacency:
                neighbors.update(position_adjacency[vertex_idx])
            return neighbors

        # Flood fill from selected vertices using deque for better performance
        from collections import deque
        visited = set()
        queue = deque(initially_selected)

        while queue:
            current = queue.popleft()
            if current in visited:
                continue

            visited.add(current)
            mesh.vertices[current].select = True

            # Add all connected vertices to queue
            for neighbor in get_neighbors(current):
                if neighbor not in visited:
                    queue.append(neighbor)

        # Select edges where both vertices are selected
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if mesh.vertices[v0].select and mesh.vertices[v1].select:
                edge.select = True

        # Select faces where all vertices are selected
        for face in mesh.polygons:
            all_verts_selected = all(mesh.vertices[v].select for v in face.vertices)
            if all_verts_selected:
                face.select = True

        # Return to edit mode
        bpy.ops.object.mode_set(mode='EDIT')

        expanded_count = len(visited) - len(initially_selected)
        self.report({'INFO'}, f"Selected {len(visited)} vertices ({expanded_count} new)")
        return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "epsilon")
        layout.label(text="Connects vertices at same location", icon='INFO')


class MESH_OT_deduplicate_submeshes(Operator):
    bl_idname = "mesh.deduplicate_submeshes"
    bl_label = "Deduplicate Submeshes"
    bl_description = "Remove duplicate submeshes from selection that have vertices at the same locations"
    bl_options = {'REGISTER', 'UNDO'}

    tolerance: FloatProperty(
        name="Position Tolerance",
        description="Maximum distance for vertices to be considered at the same position",
        default=0.0001,
        min=0.0,
        max=1.0,
        precision=6
    )

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj is not None and
                obj.type == 'MESH' and
                context.mode == 'EDIT_MESH')

    def get_selected_vertex_islands(self, mesh):
        """Find all contiguous groups of selected vertices in the mesh"""
        # Get selected vertices
        selected_indices = {v.index for v in mesh.vertices if v.select}

        if not selected_indices:
            return []

        # Build adjacency only for selected vertices
        adjacency = {idx: set() for idx in selected_indices}

        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if v0 in selected_indices and v1 in selected_indices:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)

        islands = []
        visited = set()

        for start_idx in selected_indices:
            if start_idx in visited:
                continue

            island = set()
            queue = [start_idx]

            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue

                visited.add(current)
                island.add(current)

                for neighbor in adjacency[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            islands.append(island)

        return islands

    def get_island_hash(self, mesh, island_indices):
        """Create a hash for an island based on vertex positions"""
        # Round positions to handle tolerance
        decimal_places = 6 if self.tolerance == 0 else max(0, int(-math.log10(self.tolerance)))

        positions = []
        for idx in island_indices:
            co = mesh.vertices[idx].co
            # Round each component
            rounded = (
                round(co.x, decimal_places),
                round(co.y, decimal_places),
                round(co.z, decimal_places)
            )
            positions.append(rounded)

        # Sort positions to ensure consistent ordering
        positions.sort()

        # Convert to tuple for hashing
        return tuple(positions)

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        # Switch to object mode
        bpy.ops.object.mode_set(mode='OBJECT')

        # Find all selected islands
        islands = self.get_selected_vertex_islands(mesh)

        if not islands:
            self.report({'WARNING'}, "No vertices selected")
            bpy.ops.object.mode_set(mode='EDIT')
            return {'CANCELLED'}

        if len(islands) <= 1:
            self.report({'INFO'}, "No duplicate submeshes found in selection (only 1 submesh)")
            bpy.ops.object.mode_set(mode='EDIT')
            return {'FINISHED'}

        # Group islands by their hash
        island_groups = {}
        for island in islands:
            island_hash = self.get_island_hash(mesh, island)
            if island_hash not in island_groups:
                island_groups[island_hash] = []
            island_groups[island_hash].append(island)

        # Find duplicates
        duplicates_to_remove = []
        duplicate_count = 0

        for hash_key, group in island_groups.items():
            if len(group) > 1:
                # Keep the first island, mark others for removal
                for island in group[1:]:
                    duplicates_to_remove.append(island)
                    duplicate_count += 1

        if not duplicates_to_remove:
            self.report({'INFO'}, "No duplicate submeshes found in selection")
            bpy.ops.object.mode_set(mode='EDIT')
            return {'FINISHED'}

        # Enter edit mode and select vertices to delete
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.select_all(action='DESELECT')
        bpy.ops.object.mode_set(mode='OBJECT')

        # Select all vertices in duplicate islands
        vertices_to_delete = set()
        for island in duplicates_to_remove:
            vertices_to_delete.update(island)

        for idx in vertices_to_delete:
            mesh.vertices[idx].select = True

        # Delete selected vertices
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.delete(type='VERT')

        self.report({'INFO'}, f"Removed {duplicate_count} duplicate submeshes from selection ({len(vertices_to_delete)} vertices)")
        return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "tolerance")
        layout.label(text="Set to 0 for exact matching", icon='INFO')


class MESH_OT_pack_uv_islands_by_submesh(Operator):
    bl_idname = "mesh.pack_uv_islands_by_submesh"
    bl_label = "Pack UV Islands by Submesh Z"
    bl_description = "Pack UV islands vertically sorted by submesh Z position"
    bl_options = {'REGISTER', 'UNDO'}

    padding: FloatProperty(
        name="Island Padding",
        description="Padding between UV islands",
        default=0.02,
        min=0.0,
        max=0.1,
        precision=3
    )

    max_islands_per_row: IntProperty(
        name="Max Islands Per Row",
        description="Maximum number of islands per row (use high value for width-based packing only)",
        default=100,
        min=1,
        max=1000
    )

    lock_overlapping: BoolProperty(
        name="Lock Overlapping Islands",
        description="Treat overlapping UV islands as a single island",
        default=False
    )

    skip_overlap_check: BoolProperty(
        name="Skip Overlap Check",
        description="Skip overlap detection entirely for better performance on large meshes (overrides Lock Overlapping)",
        default=False
    )

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj is not None and
                obj.type == 'MESH' and
                context.mode == 'EDIT_MESH' and
                obj.data.uv_layers.active is not None)

    def get_uv_islands(self, bm, uv_layer):
        """Find all UV islands in the mesh"""
        # Build UV edge connectivity
        uv_vert_map = {}  # Maps UV coordinates to vertex indices
        uv_edges = set()  # Set of UV edges as frozensets of UV coords

        for face in bm.faces:
            if not face.select:
                continue

            face_uvs = []
            for loop in face.loops:
                uv = loop[uv_layer].uv
                uv_key = (round(uv.x, 6), round(uv.y, 6))
                face_uvs.append(uv_key)

                if uv_key not in uv_vert_map:
                    uv_vert_map[uv_key] = set()
                uv_vert_map[uv_key].add(loop.vert.index)  # Store index instead of BMVert

            # Create UV edges
            for i in range(len(face_uvs)):
                j = (i + 1) % len(face_uvs)
                edge = frozenset([face_uvs[i], face_uvs[j]])
                uv_edges.add(edge)

        # Find UV islands using connected components
        uv_adjacency = {uv: set() for uv in uv_vert_map}

        for edge in uv_edges:
            uv_list = list(edge)
            if len(uv_list) == 2:
                uv_adjacency[uv_list[0]].add(uv_list[1])
                uv_adjacency[uv_list[1]].add(uv_list[0])

        # Find connected components
        visited = set()
        islands = []

        for start_uv in uv_vert_map:
            if start_uv in visited:
                continue

            island_uvs = set()
            island_vert_indices = set()  # Store indices instead of BMVerts
            queue = [start_uv]

            while queue:
                current_uv = queue.pop(0)
                if current_uv in visited:
                    continue

                visited.add(current_uv)
                island_uvs.add(current_uv)
                island_vert_indices.update(uv_vert_map[current_uv])

                for neighbor in uv_adjacency[current_uv]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            # Store island data with vertex indices
            islands.append({
                'uvs': island_uvs,
                'vert_indices': island_vert_indices,  # Store indices
                'loops': []  # Will be filled later
            })

        # We'll assign loops later when we have a valid BMesh
        return islands

    def get_island_bounds(self, island, uv_layer):
        """Get bounding box of UV island"""
        if not island['loops']:
            return 0, 0, 0, 0

        min_u = min_v = float('inf')
        max_u = max_v = float('-inf')

        for loop in island['loops']:
            uv = loop[uv_layer].uv
            min_u = min(min_u, uv.x)
            max_u = max(max_u, uv.x)
            min_v = min(min_v, uv.y)
            max_v = max(max_v, uv.y)

        return min_u, min_v, max_u, max_v

    def get_submesh_of_island(self, island_vert_indices, submeshes):
        """Find which submesh an island belongs to"""
        # island_vert_indices is already a set of indices

        # Find submesh with most overlap
        best_submesh = None
        best_overlap = 0

        for i, submesh in enumerate(submeshes):
            overlap = len(island_vert_indices & submesh)
            if overlap > best_overlap:
                best_overlap = overlap
                best_submesh = i

        return best_submesh

    def get_submesh_of_island_fast(self, island_vert_indices, vertex_to_submesh):
        """Find which submesh an island belongs to (optimized version)"""
        # Count vertices per submesh
        submesh_counts = {}

        for vert_idx in island_vert_indices:
            if vert_idx in vertex_to_submesh:
                submesh_idx = vertex_to_submesh[vert_idx]
                submesh_counts[submesh_idx] = submesh_counts.get(submesh_idx, 0) + 1

        # Find submesh with most vertices
        if not submesh_counts:
            return None

        best_submesh = max(submesh_counts.items(), key=lambda x: x[1])
        return best_submesh[0]

    def check_islands_overlap(self, island1, island2, uv_layer):
        """Check if two UV islands overlap"""
        # First check bounding box overlap
        bounds1 = self.get_island_bounds(island1, uv_layer)
        bounds2 = self.get_island_bounds(island2, uv_layer)

        # Check if bounding boxes don't overlap
        if (bounds1[2] < bounds2[0] or bounds2[2] < bounds1[0] or
            bounds1[3] < bounds2[1] or bounds2[3] < bounds1[1]):
            return False

        # For precise overlap, check if any UV coordinates are shared
        # This is sufficient for most use cases (exact overlapping vertices)
        return bool(island1['uvs'] & island2['uvs'])

    def merge_overlapping_islands(self, islands, uv_layer):
        """Merge overlapping UV islands into groups"""
        if not self.lock_overlapping:
            return islands

        num_islands = len(islands)

        # Skip for very large numbers of islands
        if num_islands > 1000:
            self.report({'WARNING'}, f"Skipping overlap detection for {num_islands} islands (too many)")
            return islands

        # Pre-calculate bounds for all islands
        island_bounds = []
        for island in islands:
            bounds = self.get_island_bounds(island, uv_layer)
            island_bounds.append(bounds)

        # Build overlap graph with bounding box pre-filtering
        overlap_graph = {i: set() for i in range(num_islands)}

        # Use spatial subdivision for large island counts
        if num_islands > 200:
            # Create spatial grid for broad phase
            grid_size = 10
            spatial_grid = {}

            for i, bounds in enumerate(island_bounds):
                if bounds[0] == bounds[2] and bounds[1] == bounds[3]:
                    continue  # Skip degenerate islands

                # Determine grid cells this island touches
                min_x = int(bounds[0] * grid_size)
                max_x = int(bounds[2] * grid_size)
                min_y = int(bounds[1] * grid_size)
                max_y = int(bounds[3] * grid_size)

                for gx in range(min_x, max_x + 1):
                    for gy in range(min_y, max_y + 1):
                        grid_key = (gx, gy)
                        if grid_key not in spatial_grid:
                            spatial_grid[grid_key] = []
                        spatial_grid[grid_key].append(i)

            # Check overlaps only within same grid cells
            checked_pairs = set()
            for cell_islands in spatial_grid.values():
                for i, idx1 in enumerate(cell_islands):
                    for idx2 in cell_islands[i + 1:]:
                        pair = (min(idx1, idx2), max(idx1, idx2))
                        if pair in checked_pairs:
                            continue
                        checked_pairs.add(pair)

                        # Quick bounding box check
                        b1, b2 = island_bounds[idx1], island_bounds[idx2]
                        if not (b1[2] < b2[0] or b2[2] < b1[0] or
                                b1[3] < b2[1] or b2[3] < b1[1]):
                            # Detailed overlap check
                            if islands[idx1]['uvs'] & islands[idx2]['uvs']:
                                overlap_graph[idx1].add(idx2)
                                overlap_graph[idx2].add(idx1)
        else:
            # Original O(n²) algorithm for smaller counts
            for i in range(num_islands):
                for j in range(i + 1, num_islands):
                    # Quick bounding box check first
                    b1, b2 = island_bounds[i], island_bounds[j]
                    if not (b1[2] < b2[0] or b2[2] < b1[0] or
                            b1[3] < b2[1] or b2[3] < b1[1]):
                        # Detailed overlap check
                        if islands[i]['uvs'] & islands[j]['uvs']:
                            overlap_graph[i].add(j)
                            overlap_graph[j].add(i)

        # Find connected components (groups of overlapping islands)
        visited = set()
        merged_islands = []

        for start_idx in range(num_islands):
            if start_idx in visited:
                continue

            # Find all islands connected to this one
            group_indices = set()
            queue = [start_idx]

            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue

                visited.add(current)
                group_indices.add(current)

                for neighbor in overlap_graph[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            # Merge islands in this group
            if len(group_indices) == 1:
                # Single island, no merge needed
                merged_islands.append(islands[start_idx])
            else:
                # Merge multiple islands
                merged_uvs = set()
                merged_vert_indices = set()
                merged_loops = []

                for idx in group_indices:
                    island = islands[idx]
                    merged_uvs.update(island['uvs'])
                    merged_vert_indices.update(island['vert_indices'])
                    merged_loops.extend(island['loops'])

                merged_islands.append({
                    'uvs': merged_uvs,
                    'vert_indices': merged_vert_indices,
                    'loops': merged_loops
                })

        return merged_islands

    def get_submesh_avg_z(self, mesh, submesh_indices):
        """Calculate average Z position of a submesh"""
        if not submesh_indices:
            return 0.0

        total_z = 0.0
        for idx in submesh_indices:
            total_z += mesh.vertices[idx].co.z

        return total_z / len(submesh_indices)

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        # Get UV layer
        uv_layer = mesh.uv_layers.active
        if not uv_layer:
            self.report({'ERROR'}, "No active UV layer")
            return {'CANCELLED'}

        # Create BMesh
        bm = bmesh.from_edit_mesh(mesh)
        bm_uv_layer = bm.loops.layers.uv.active

        # Get UV islands from selected faces
        uv_islands = self.get_uv_islands(bm, bm_uv_layer)

        if not uv_islands:
            self.report({'WARNING'}, "No UV islands found in selection")
            return {'CANCELLED'}

        # Performance warning for large meshes
        if len(uv_islands) > 500 and self.lock_overlapping:
            self.report({'WARNING'}, f"Processing {len(uv_islands)} islands with overlap detection may be slow")

        # Merge overlapping islands if requested
        original_count = len(uv_islands)
        if self.skip_overlap_check:
            merged_count = 0
        else:
            uv_islands = self.merge_overlapping_islands(uv_islands, bm_uv_layer)
            merged_count = original_count - len(uv_islands)

        # Get submeshes (vertex islands)
        bpy.ops.object.mode_set(mode='OBJECT')

        # Get selected vertices for submesh detection
        selected_indices = {v.index for v in mesh.vertices if v.select}

        # Build submeshes (reusing logic from other operators)
        adjacency = {idx: set() for idx in selected_indices}
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if v0 in selected_indices and v1 in selected_indices:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)

        submeshes = []
        visited = set()

        # Build vertex-to-submesh mapping for O(1) lookups
        vertex_to_submesh = {}
        submesh_idx = 0

        for start_idx in selected_indices:
            if start_idx in visited:
                continue

            submesh = set()
            queue = [start_idx]

            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue

                visited.add(current)
                submesh.add(current)
                vertex_to_submesh[current] = submesh_idx

                for neighbor in adjacency[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            submeshes.append(submesh)
            submesh_idx += 1

        # Calculate average Z for each submesh
        submesh_z_values = []
        for submesh in submeshes:
            avg_z = self.get_submesh_avg_z(mesh, submesh)
            submesh_z_values.append(avg_z)

        # Return to edit mode to work with BMesh
        bpy.ops.object.mode_set(mode='EDIT')
        bm = bmesh.from_edit_mesh(mesh)
        bm_uv_layer = bm.loops.layers.uv.active

        # Build UV-to-loops mapping once for all islands
        uv_to_loops = {}
        for face in bm.faces:
            if not face.select:
                continue

            for loop in face.loops:
                uv = loop[bm_uv_layer].uv
                uv_key = (round(uv.x, 6), round(uv.y, 6))

                if uv_key not in uv_to_loops:
                    uv_to_loops[uv_key] = []
                uv_to_loops[uv_key].append(loop)

        # Assign loops to islands efficiently
        for island in uv_islands:
            island['loops'] = []
            for uv_key in island['uvs']:
                if uv_key in uv_to_loops:
                    island['loops'].extend(uv_to_loops[uv_key])

        # Assign UV islands to submeshes and get bounds
        island_data = []
        for island in uv_islands:
            submesh_idx = self.get_submesh_of_island_fast(island['vert_indices'], vertex_to_submesh)
            if submesh_idx is not None and island['loops']:  # Make sure we have loops
                bounds = self.get_island_bounds(island, bm_uv_layer)
                width = bounds[2] - bounds[0]
                height = bounds[3] - bounds[1]

                # Skip degenerate islands
                if width <= 0 or height <= 0:
                    continue

                island_data.append({
                    'island': island,
                    'submesh_idx': submesh_idx,
                    'submesh_z': submesh_z_values[submesh_idx],
                    'bounds': bounds,
                    'width': width,
                    'height': height,
                    'min_u': bounds[0],
                    'min_v': bounds[1]
                })

        # Sort islands by submesh Z (descending, so higher Z is at top of UV space)
        island_data.sort(key=lambda x: x['submesh_z'], reverse=True)

        # Calculate total area needed
        total_area = 0
        max_island_size = 0
        for data in island_data:
            area = (data['width'] + self.padding) * (data['height'] + self.padding)
            total_area += area
            max_island_size = max(max_island_size, max(data['width'], data['height']))

        # Calculate optimal dimensions considering row constraints
        num_islands = len(island_data)
        min_rows_needed = math.ceil(num_islands / self.max_islands_per_row)

        # Calculate average island dimensions
        avg_width = sum(data['width'] for data in island_data) / num_islands if num_islands > 0 else 0
        avg_height = sum(data['height'] for data in island_data) / num_islands if num_islands > 0 else 0

        # Estimate dimensions based on constraints
        if self.max_islands_per_row < 10:  # User wants specific column layout
            # Width based on max islands per row
            estimated_width = self.max_islands_per_row * (avg_width + self.padding)
            # Height based on minimum rows needed
            estimated_height = min_rows_needed * (avg_height + self.padding)
            # Use the larger dimension to maintain reasonable aspect ratio
            target_size = max(estimated_width, math.sqrt(total_area) * 1.1)
        else:
            # Default behavior: aim for square packing
            target_size = max(math.sqrt(total_area) * 1.2, max_island_size + 2 * self.padding)

        # Scale to fit in UV space (0-1)
        if target_size > 1.0:
            scale_factor = 0.95 / target_size  # Leave some margin
            # Scale all islands
            for data in island_data:
                data['width'] *= scale_factor
                data['height'] *= scale_factor
                # Update bounds to scaled values
                data['scaled_min_u'] = data['min_u'] * scale_factor
                data['scaled_min_v'] = data['min_v'] * scale_factor
                data['scaled_max_v'] = (data['bounds'][3] - data['bounds'][1]) * scale_factor + data['scaled_min_v']
            target_size = 0.95
        else:
            scale_factor = 1.0
            # Even without scaling, store the values for consistency
            for data in island_data:
                data['scaled_min_u'] = data['min_u']
                data['scaled_min_v'] = data['min_v']
                data['scaled_max_v'] = data['bounds'][3]

        # Pack islands using a simple shelf packing algorithm
        rows = []
        current_row = []
        current_row_height = 0
        current_row_width = 0

        for data in island_data:
            width = data['width']
            height = data['height']

            # Check if island fits in current row (both width and count constraints)
            fits_width = current_row_width + width + self.padding <= target_size or not current_row
            under_max_count = len(current_row) < self.max_islands_per_row

            if fits_width and under_max_count:
                # Add to current row
                current_row.append(data)
                current_row_width += width + self.padding
                current_row_height = max(current_row_height, height)
            else:
                # Start new row (only append if current row is not empty)
                if current_row:
                    rows.append((current_row, current_row_height))
                current_row = [data]
                current_row_width = width + self.padding
                current_row_height = height

        # Add last row
        if current_row:
            rows.append((current_row, current_row_height))

        # Calculate actual bounding box height
        total_height = sum(row[1] for row in rows) + self.padding * (len(rows) + 1)

        # Center the packed result in UV space
        start_u = (1.0 - target_size) / 2.0
        start_v = (1.0 - min(total_height, 1.0)) / 2.0 + min(total_height, 1.0)

        # Place islands
        current_v = start_v

        for row_idx, (row_islands, row_height) in enumerate(rows):
            # Center row horizontally
            row_actual_width = sum(data['width'] for data in row_islands) + self.padding * (len(row_islands) - 1)
            current_u = start_u + (target_size - row_actual_width) / 2.0

            # Find the actual top of this row (highest point of any island)
            row_top = current_v

            for data in row_islands:
                # Calculate offset to position island at current location
                # We want the TOP of the island's bounding box at row_top
                offset_u = current_u - data['scaled_min_u']
                offset_v = row_top - data['scaled_max_v']

                # Move all UVs in this island
                for loop in data['island']['loops']:
                    uv = loop[bm_uv_layer].uv
                    uv.x = uv.x * scale_factor + offset_u
                    uv.y = uv.y * scale_factor + offset_v

                current_u += data['width'] + self.padding

            # Move down by the full height of the row plus extra spacing
            current_v = row_top - row_height - self.padding

        # Update mesh
        bmesh.update_edit_mesh(mesh)

        # Report results
        if self.lock_overlapping and merged_count > 0:
            self.report({'INFO'}, f"Packed {len(island_data)} UV islands ({merged_count} overlapping merged) from {len(submeshes)} submeshes")
        else:
            self.report({'INFO'}, f"Packed {len(island_data)} UV islands from {len(submeshes)} submeshes")
        return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "padding")
        layout.prop(self, "max_islands_per_row")
        layout.prop(self, "lock_overlapping")
        layout.prop(self, "skip_overlap_check")

        if self.skip_overlap_check and self.lock_overlapping:
            layout.label(text="Skip Overlap overrides Lock Overlapping", icon='INFO')

        layout.label(text="Higher Z submeshes → Higher V position", icon='INFO')

        # Performance hints
        col = layout.column()
        col.scale_y = 0.8
        col.label(text="Performance tips:", icon='TIME')
        col.label(text="• Use Skip Overlap for >500 islands")
        col.label(text="• Set Max Islands/Row for control")


class MESH_OT_merge_by_distance_in_submeshes(Operator):
    bl_idname = "mesh.merge_by_distance_in_submeshes"
    bl_label = "Merge by Distance (Per Submesh)"
    bl_description = "Merge vertices by distance within each submesh separately"
    bl_options = {'REGISTER', 'UNDO'}

    merge_distance: FloatProperty(
        name="Merge Distance",
        description="Maximum distance for merging vertices",
        default=0.001,
        min=0.0,
        max=1.0,
        precision=6,
        subtype='DISTANCE'
    )

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj is not None and
                obj.type == 'MESH' and
                context.mode == 'EDIT_MESH')

    def get_selected_vertex_islands(self, mesh):
        """Find all contiguous groups of selected vertices - works like other operators"""
        # Get selected vertices
        selected_indices = {v.index for v in mesh.vertices if v.select}

        if not selected_indices:
            return []

        # Build adjacency only for selected vertices
        adjacency = {idx: set() for idx in selected_indices}

        # Only check edges that might connect selected vertices
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if v0 in selected_indices and v1 in selected_indices:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)

        islands = []
        visited = set()

        from collections import deque

        for start_idx in selected_indices:
            if start_idx in visited:
                continue

            island = set()
            queue = deque([start_idx])

            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue

                visited.add(current)
                island.add(current)

                for neighbor in adjacency[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            islands.append(island)

        return islands

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        # Use the most efficient approach: single merge with island constraints
        bm = bmesh.from_edit_mesh(mesh)

        # Get selected vertices
        selected_verts = [v for v in bm.verts if v.select]
        if not selected_verts:
            self.report({'WARNING'}, "No vertices selected")
            return {'CANCELLED'}

        # Build islands using optimized algorithm
        selected_set = set(selected_verts)
        vert_to_island = {}
        island_id = 0

        # Find islands with stack-based traversal
        for v in selected_verts:
            if v in vert_to_island:
                continue

            # Mark all vertices in this island
            stack = [v]
            while stack:
                current = stack.pop()
                if current in vert_to_island:
                    continue

                vert_to_island[current] = island_id

                # Add connected vertices
                for edge in current.link_edges:
                    other = edge.other_vert(current)
                    if other in selected_set and other not in vert_to_island:
                        stack.append(other)

            island_id += 1

        # Build merge mapping manually to avoid repeated operations
        merge_targets = {}
        total_merged = 0
        islands_with_merges = 0

        # For each island, find vertices to merge
        from collections import defaultdict
        island_verts = defaultdict(list)
        for v, iid in vert_to_island.items():
            island_verts[iid].append(v)

        # Process each island
        for island_id, verts in island_verts.items():
            if len(verts) < 2:
                continue

            # Build spatial hash for this island only
            merge_dist_sq = self.merge_distance * self.merge_distance
            merged_in_island = 0

            # Simple O(n²) for small islands is often faster than spatial hashing
            # Most submeshes have 10-50 verts, so this is actually efficient
            processed = set()
            for i, v1 in enumerate(verts):
                if v1 in merge_targets or v1 in processed:
                    continue

                processed.add(v1)

                # Find vertices within merge distance
                for v2 in verts[i+1:]:
                    if v2 in merge_targets or v2 in processed:
                        continue

                    # Check distance
                    diff = v1.co - v2.co
                    if diff.length_squared <= merge_dist_sq:
                        merge_targets[v2] = v1
                        processed.add(v2)
                        merged_in_island += 1

            if merged_in_island > 0:
                total_merged += merged_in_island
                islands_with_merges += 1

        # Now perform all merges in one go using BMesh weld
        if merge_targets:
            # Convert merge mapping to format expected by weld_verts
            targetmap = {v: merge_targets[v] for v in merge_targets if v.is_valid}

            if targetmap:
                bmesh.ops.weld_verts(bm, targetmap=targetmap)

        # Update the mesh
        bmesh.update_edit_mesh(mesh)

        total_islands = len(island_verts)
        multi_vert_islands = sum(1 for verts in island_verts.values() if len(verts) >= 2)
        single_vert_islands = total_islands - multi_vert_islands

        if total_merged > 0:
            self.report({'INFO'}, f"Merged {total_merged} vertices in {islands_with_merges} of {multi_vert_islands} submeshes (skipped {single_vert_islands} single-vertex)")
        else:
            self.report({'INFO'}, f"No vertices close enough to merge in {multi_vert_islands} submeshes")

        return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "merge_distance")
        layout.label(text="Merges within submeshes only", icon='INFO')


class MESH_OT_bake_vertex_and_rotation_combined(Operator):
    bl_idname = "mesh.bake_vertex_and_rotation_combined"
    bl_label = "Bake Vectors & Rotation Combined"
    bl_description = "Bake vertex vectors relative to orthonormal basis and orientation quaternions in one operation"
    bl_options = {'REGISTER', 'UNDO'}

    contiguous_mode: BoolProperty(
        name="Contiguous Groups",
        description="Process each contiguous group of vertices separately with its own center and scale",
        default=False
    )

    normal_epsilon: FloatProperty(
        name="Normal Epsilon",
        description="Minimum angle difference (radians) between normals to consider them unique",
        default=0.1,
        min=0.01,
        max=1.0,
        precision=3
    )

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj is not None and
                obj.type == 'MESH' and
                context.mode == 'EDIT_MESH')

    def get_vertex_islands(self, mesh, selected_indices):
        """Find contiguous groups of vertices using edge connectivity"""
        adjacency = {idx: set() for idx in selected_indices}

        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if v0 in selected_indices and v1 in selected_indices:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)

        islands = []
        visited = set()

        for start_idx in selected_indices:
            if start_idx in visited:
                continue

            island = set()
            queue = [start_idx]

            while queue:
                current = queue.pop(0)
                if current in visited:
                    continue

                visited.add(current)
                island.add(current)

                for neighbor in adjacency[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)

            islands.append(island)

        return islands

    def get_submesh_faces_and_normals(self, mesh, island_indices):
        """Get all faces and their normals for vertices in the island"""
        faces_data = []

        # Build vertex to faces mapping for efficiency
        vertex_to_faces = {}
        for face_idx, face in enumerate(mesh.polygons):
            for vertex_idx in face.vertices:
                if vertex_idx in island_indices:
                    if vertex_idx not in vertex_to_faces:
                        vertex_to_faces[vertex_idx] = []
                    vertex_to_faces[vertex_idx].append(face_idx)

        # Collect unique faces that belong to this island
        island_faces = set()
        for vertex_idx in island_indices:
            if vertex_idx in vertex_to_faces:
                for face_idx in vertex_to_faces[vertex_idx]:
                    face = mesh.polygons[face_idx]
                    # Check if all vertices of this face are in the island
                    if all(v in island_indices for v in face.vertices):
                        island_faces.add(face_idx)

        # Calculate face data
        for face_idx in island_faces:
            face = mesh.polygons[face_idx]
            faces_data.append({
                'normal': face.normal.copy(),
                'area': face.area,
                'index': face_idx
            })

        return faces_data

    def build_orthonormal_basis_from_faces(self, faces_data, epsilon):
        """Build orthonormal basis from face normals"""
        if not faces_data:
            # Default to standard basis if no faces
            return mathutils.Matrix.Identity(3)

        # Sort faces by area (largest first)
        faces_data.sort(key=lambda x: x['area'], reverse=True)

        # Find up to 3 non-parallel normals
        basis_normals = []
        epsilon_cos = math.cos(epsilon)

        for face_data in faces_data:
            normal = face_data['normal'].normalized()

            # Check if this normal is sufficiently different from existing ones
            is_unique = True
            for existing_normal in basis_normals:
                dot_product = abs(normal.dot(existing_normal))
                if dot_product > epsilon_cos:
                    is_unique = False
                    break

            if is_unique:
                basis_normals.append(normal)
                if len(basis_normals) >= 3:
                    break

        # Build orthonormal basis
        if len(basis_normals) == 0:
            # No faces, use default
            return mathutils.Matrix.Identity(3)

        # First basis vector is the largest face normal
        x_axis = basis_normals[0].normalized()

        if len(basis_normals) >= 2:
            # Use second normal to define y-axis
            y_candidate = basis_normals[1]
            # Make it orthogonal to x
            y_axis = (y_candidate - y_candidate.project(x_axis)).normalized()

            # If y_axis is too small (normals were almost parallel), find a different vector
            if y_axis.length < 0.1:
                # Create arbitrary perpendicular vector
                if abs(x_axis.z) < 0.9:
                    y_axis = mathutils.Vector((0, 0, 1)).cross(x_axis).normalized()
                else:
                    y_axis = mathutils.Vector((1, 0, 0)).cross(x_axis).normalized()
        else:
            # Only one unique normal, create arbitrary perpendicular
            if abs(x_axis.z) < 0.9:
                y_axis = mathutils.Vector((0, 0, 1)).cross(x_axis).normalized()
            else:
                y_axis = mathutils.Vector((1, 0, 0)).cross(x_axis).normalized()

        # Third axis from cross product
        z_axis = x_axis.cross(y_axis).normalized()

        # Build rotation matrix (columns are the basis vectors)
        matrix = mathutils.Matrix((
            (x_axis.x, y_axis.x, z_axis.x),
            (x_axis.y, y_axis.y, z_axis.y),
            (x_axis.z, y_axis.z, z_axis.z)
        ))

        # Ensure right-handed coordinate system
        if matrix.determinant() < 0:
            z_axis = -z_axis
            matrix = mathutils.Matrix((
                (x_axis.x, y_axis.x, z_axis.x),
                (x_axis.y, y_axis.y, z_axis.y),
                (x_axis.z, y_axis.z, z_axis.z)
            ))

        return matrix

    def get_island_info(self, mesh, island_indices):
        """Calculate center and scale for a single island"""
        verts = []
        for idx in island_indices:
            verts.append(mesh.vertices[idx].co)

        if not verts:
            return None, None, None

        center = mathutils.Vector((0, 0, 0))
        for co in verts:
            center += co
        center /= len(verts)

        max_dist = 0.0
        for co in verts:
            vec = co - center
            max_component = max(abs(vec.x), abs(vec.y), abs(vec.z))
            max_dist = max(max_dist, max_component)

        if max_dist > 0:
            scale = 1.0 / max_dist
        else:
            scale = 1.0

        return center, max_dist, scale

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        try:
            bpy.ops.object.mode_set(mode='OBJECT')
        except Exception as e:
            self.report({'ERROR'}, f"Failed to switch to object mode: {str(e)}")
            return {'CANCELLED'}

        selected_indices = {v.index for v in mesh.vertices if v.select}

        if not selected_indices:
            self.report({'WARNING'}, "No vertices selected")
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except:
                pass
            return {'CANCELLED'}

        # Check if mesh has faces
        if not mesh.polygons:
            self.report({'ERROR'}, "Mesh has no faces. Both vertex colors and quaternion baking require faces.")
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except:
                pass
            return {'CANCELLED'}

        # Create vertex color layer
        if not mesh.vertex_colors:
            mesh.vertex_colors.new(name="BakedVectors")
        color_layer = mesh.vertex_colors.active
        if not color_layer:
            self.report({'ERROR'}, "Failed to create vertex color layer")
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except:
                pass
            return {'CANCELLED'}

        # Remove existing UV maps and create new ones for quaternions
        uv_names = ["BakedOriginAngle0", "BakedOriginAngle1"]
        for uv_name in uv_names:
            if uv_name in mesh.uv_layers:
                mesh.uv_layers.remove(mesh.uv_layers[uv_name])

        uv_layer0 = mesh.uv_layers.new(name="BakedOriginAngle0")
        uv_layer1 = mesh.uv_layers.new(name="BakedOriginAngle1")

        if not uv_layer0 or not uv_layer1:
            self.report({'ERROR'}, "Failed to create UV layers")
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except:
                pass
            return {'CANCELLED'}

        source_matrix = obj.matrix_world

        if self.contiguous_mode:
            # Build vertex to polygon mapping for efficiency
            vertex_to_polys = {}
            for poly_idx, poly in enumerate(mesh.polygons):
                for vertex_idx in poly.vertices:
                    if vertex_idx in selected_indices:
                        if vertex_idx not in vertex_to_polys:
                            vertex_to_polys[vertex_idx] = []
                        vertex_to_polys[vertex_idx].append(poly_idx)

            islands = self.get_vertex_islands(mesh, selected_indices)
            total_updated = 0

            # Process each island separately
            for island_indices in islands:
                # Get vector data for this island
                center, max_dist, scale = self.get_island_info(mesh, island_indices)
                if center is None:
                    continue

                # Get face data and build orthonormal basis for this island
                faces_data = self.get_submesh_faces_and_normals(mesh, island_indices)
                basis_matrix = self.build_orthonormal_basis_from_faces(faces_data, self.normal_epsilon)
                
                # Convert basis to quaternion
                quaternion = basis_matrix.to_quaternion()
                quaternion.normalize()

                if quaternion.w < 0:
                    quaternion.negate()

                center_world = source_matrix @ center

                # Collect all polygons that contain vertices from this island
                relevant_polys = set()
                for vertex_idx in island_indices:
                    if vertex_idx in vertex_to_polys:
                        relevant_polys.update(vertex_to_polys[vertex_idx])

                # Only process relevant polygons
                for poly_idx in relevant_polys:
                    poly = mesh.polygons[poly_idx]
                    for loop_idx in poly.loop_indices:
                        vertex_idx = mesh.loops[loop_idx].vertex_index

                        if vertex_idx in island_indices:
                            vertex = mesh.vertices[vertex_idx]

                            # Calculate vector from vertex to center in world space
                            vertex_world = source_matrix @ vertex.co
                            vector_world = vertex_world - center_world
                            
                            # Transform to object space
                            vector_object = source_matrix.inverted_safe().to_3x3() @ vector_world
                            
                            # Transform vector to local orthonormal basis coordinates
                            # Use transpose of basis matrix to transform from object to local
                            vector_local = basis_matrix.transposed() @ vector_object
                            
                            # Apply scale
                            vector_scaled = vector_local * scale

                            # Store transformed vector in vertex colors
                            color = mathutils.Vector((
                                (vector_scaled.x + 1.0) * 0.5,
                                (vector_scaled.y + 1.0) * 0.5,
                                (vector_scaled.z + 1.0) * 0.5,
                                scale
                            ))
                            color_layer.data[loop_idx].color = color

                            # Store quaternion in UV coordinates
                            uv_layer0.data[loop_idx].uv = mathutils.Vector((quaternion.x, quaternion.y))
                            uv_layer1.data[loop_idx].uv = mathutils.Vector((quaternion.z, quaternion.w))
                            
                            total_updated += 1

            mesh.update()

            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except Exception as e:
                self.report({'WARNING'}, f"Could not return to edit mode: {str(e)}")

            self.report({'INFO'}, f"Baked vectors & quaternions for {len(islands)} contiguous groups ({len(selected_indices)} vertices)")
            return {'FINISHED'}

        else:
            # Single group mode - process all selected vertices as one group
            
            # Get vector data
            verts = []
            for idx in selected_indices:
                verts.append(mesh.vertices[idx].co)

            center = mathutils.Vector((0, 0, 0))
            for co in verts:
                center += co
            center /= len(verts)

            max_dist = 0.0
            for co in verts:
                vec = co - center
                max_component = max(abs(vec.x), abs(vec.y), abs(vec.z))
                max_dist = max(max_dist, max_component)

            if max_dist > 0:
                scale = 1.0 / max_dist
            else:
                scale = 1.0

            # Get face data and build orthonormal basis for all selected vertices
            faces_data = self.get_submesh_faces_and_normals(mesh, selected_indices)
            basis_matrix = self.build_orthonormal_basis_from_faces(faces_data, self.normal_epsilon)
            
            # Convert basis to quaternion
            quaternion = basis_matrix.to_quaternion()
            quaternion.normalize()

            if quaternion.w < 0:
                quaternion.negate()

            center_world = source_matrix @ center

            updated_count = 0
            for poly in mesh.polygons:
                for loop_idx in poly.loop_indices:
                    vertex_idx = mesh.loops[loop_idx].vertex_index

                    if vertex_idx in selected_indices:
                        vertex = mesh.vertices[vertex_idx]

                        # Calculate vector from vertex to center in world space
                        vertex_world = source_matrix @ vertex.co
                        vector_world = vertex_world - center_world
                        
                        # Transform to object space
                        vector_object = source_matrix.inverted_safe().to_3x3() @ vector_world
                        
                        # Transform vector to local orthonormal basis coordinates
                        vector_local = basis_matrix.transposed() @ vector_object
                        
                        # Apply scale
                        vector_scaled = vector_local * scale

                        # Store transformed vector in vertex colors
                        color = mathutils.Vector((
                            (vector_scaled.x + 1.0) * 0.5,
                            (vector_scaled.y + 1.0) * 0.5,
                            (vector_scaled.z + 1.0) * 0.5,
                            scale
                        ))
                        color_layer.data[loop_idx].color = color

                        # Store quaternion in UV coordinates
                        uv_layer0.data[loop_idx].uv = mathutils.Vector((quaternion.x, quaternion.y))
                        uv_layer1.data[loop_idx].uv = mathutils.Vector((quaternion.z, quaternion.w))
                        
                        updated_count += 1

            mesh.update()

            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except Exception as e:
                self.report({'WARNING'}, f"Could not return to edit mode: {str(e)}")

            self.report({'INFO'}, f"Baked vectors & quaternion for {len(selected_indices)} vertices with scale {scale:.3f}")
            return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "contiguous_mode")
        layout.prop(self, "normal_epsilon")
        layout.label(text="Vectors relative to orthonormal basis", icon='INFO')
        layout.label(text="Stores quaternion in UV maps:", icon='INFO')
        layout.label(text="  BakedOriginAngle0: X, Y components")
        layout.label(text="  BakedOriginAngle1: Z, W components")


class MESH_PT_bake_vertex_panel(Panel):
    bl_label = "Bake Vertex Vectors"
    bl_idname = "MESH_PT_bake_vertex_vectors"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = "Tool"

    def draw(self, context):
        layout = self.layout
        obj = context.active_object

        col = layout.column()

        if obj and obj.type == 'MESH':
            if context.mode == 'EDIT_MESH':
                col.operator("mesh.select_all_linked_submeshes", icon='SELECT_EXTEND')
                col.operator("mesh.select_linked_across_boundaries", icon='LINKED')
                col.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
                col.operator("mesh.merge_by_distance_in_submeshes", icon='AUTOMERGE_ON')
                col.operator("mesh.pack_uv_islands_by_submesh", icon='UV')
                col.separator()
                
                # Combined operator
                col.operator("mesh.bake_vertex_and_rotation_combined", icon='EXPORT', text="Bake Vectors & Rotation")

                box = col.box()
                box.label(text="Info:", icon='INFO')
                box.label(text="Select All Linked: Expand selection to full submeshes")
                box.label(text="Select Linked Cross: Select linked across boundaries")
                box.label(text="Deduplicate: Remove duplicate selected submeshes")
                box.label(text="Merge: Merge vertices within submeshes")
                box.label(text="Pack UV Islands: Sort UV islands by submesh Z position")
                box.label(text="Bake Vectors & Rotation: Bake vectors relative to")
                box.label(text="  orthonormal basis & orientation quaternions")
                box.label(text="Toggle Contiguous Groups for separate islands")
                box.label(text="Vectors stored in vertex colors, quaternions in UV maps")
                box.label(text="Scale factor stored in alpha channel")

                mesh = obj.data
                if mesh.vertex_colors and len(mesh.vertex_colors) > 0:
                    col.separator()
                    col.label(text=f"Active: {mesh.vertex_colors.active.name}", icon='GROUP_VCOL')
            else:
                col.label(text="Enter Edit Mode to bake vertices", icon='INFO')
        else:
            col.label(text="Select a mesh object", icon='ERROR')


classes = [
    MESH_OT_bake_vertex_and_rotation_combined,
    MESH_OT_select_all_linked_submeshes,
    MESH_OT_select_linked_across_boundaries,
    MESH_OT_deduplicate_submeshes,
    MESH_OT_pack_uv_islands_by_submesh,
    MESH_OT_merge_by_distance_in_submeshes,
    MESH_PT_bake_vertex_panel
]


def menu_func(self, context):
    self.layout.separator()
    self.layout.operator("mesh.select_all_linked_submeshes", icon='SELECT_EXTEND')
    self.layout.operator("mesh.select_linked_across_boundaries", icon='LINKED')
    self.layout.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
    self.layout.operator("mesh.merge_by_distance_in_submeshes", icon='AUTOMERGE_ON')
    self.layout.operator("mesh.pack_uv_islands_by_submesh", icon='UV')
    self.layout.operator("mesh.bake_vertex_and_rotation_combined", icon='EXPORT')


def register():
    for cls in classes:
        bpy.utils.register_class(cls)
    bpy.types.VIEW3D_MT_edit_mesh.append(menu_func)


def unregister():
    bpy.types.VIEW3D_MT_edit_mesh.remove(menu_func)
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)


if __name__ == "__main__":
    register()
