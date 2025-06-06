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
from bpy.props import BoolProperty, FloatProperty
from bpy.types import Panel, Operator


class MESH_OT_bake_vertex_vectors(Operator):
    bl_idname = "mesh.bake_vertex_vectors"
    bl_label = "Bake Vertex Vectors"
    bl_description = "Bake selected vertices with automatic center and scale calculation"
    bl_options = {'REGISTER', 'UNDO'}
    
    contiguous_mode: BoolProperty(
        name="Contiguous Groups",
        description="Process each contiguous group of vertices separately with its own center and scale",
        default=False
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
            self.report({'ERROR'}, "Mesh has no faces. Vertex colors require faces to store data.")
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except:
                pass
            return {'CANCELLED'}
        
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
            
            for island_indices in islands:
                center, max_dist, scale = self.get_island_info(mesh, island_indices)
                if center is None:
                    continue
                
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
                            
                            vertex_world = source_matrix @ vertex.co
                            vector_world = center_world - vertex_world
                            vector_object = source_matrix.inverted_safe().to_3x3() @ vector_world
                            vector_scaled = vector_object * scale
                            
                            color = mathutils.Vector((
                                (vector_scaled.x + 1.0) * 0.5,
                                (vector_scaled.y + 1.0) * 0.5,
                                (vector_scaled.z + 1.0) * 0.5,
                                scale
                            ))
                            
                            color_layer.data[loop_idx].color = color
                            total_updated += 1
            
            mesh.update()
            
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except Exception as e:
                self.report({'WARNING'}, f"Could not return to edit mode: {str(e)}")
            
            self.report({'INFO'}, f"Baked {len(islands)} contiguous groups ({len(selected_indices)} vertices)")
            return {'FINISHED'}
            
        else:
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
            
            center_world = source_matrix @ center
            
            updated_count = 0
            for poly in mesh.polygons:
                for loop_idx in poly.loop_indices:
                    vertex_idx = mesh.loops[loop_idx].vertex_index
                    
                    if vertex_idx in selected_indices:
                        vertex = mesh.vertices[vertex_idx]
                        
                        vertex_world = source_matrix @ vertex.co
                        vector_world = center_world - vertex_world
                        vector_object = source_matrix.inverted_safe().to_3x3() @ vector_world
                        vector_scaled = vector_object * scale
                        
                        color = mathutils.Vector((
                            (vector_scaled.x + 1.0) * 0.5,
                            (vector_scaled.y + 1.0) * 0.5,
                            (vector_scaled.z + 1.0) * 0.5,
                            scale
                        ))
                        
                        color_layer.data[loop_idx].color = color
                        updated_count += 1
            
            mesh.update()
            
            try:
                bpy.ops.object.mode_set(mode='EDIT')
            except Exception as e:
                self.report({'WARNING'}, f"Could not return to edit mode: {str(e)}")
            
            self.report({'INFO'}, f"Baked {len(selected_indices)} vertices with scale {scale:.3f}")
            return {'FINISHED'}
    
    def draw(self, context):
        layout = self.layout
        layout.prop(self, "contiguous_mode")


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
                current = queue.popleft()
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
                col.separator()
                col.operator("mesh.bake_vertex_vectors", icon='EXPORT')
                
                box = col.box()
                box.label(text="Info:", icon='INFO')
                box.label(text="Select All Linked: Expand selection to full submeshes")
                box.label(text="Select Linked Cross: Select linked across boundaries")
                box.label(text="Deduplicate: Remove duplicate selected submeshes")
                box.label(text="Merge: Merge vertices within submeshes")
                box.label(text="Bake: Auto-scale selected vertices")
                box.label(text="Toggle Contiguous Groups for separate islands")
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
    MESH_OT_bake_vertex_vectors,
    MESH_OT_select_all_linked_submeshes,
    MESH_OT_select_linked_across_boundaries,
    MESH_OT_deduplicate_submeshes,
    MESH_OT_merge_by_distance_in_submeshes,
    MESH_PT_bake_vertex_panel
]


def menu_func(self, context):
    self.layout.separator()
    self.layout.operator("mesh.select_all_linked_submeshes", icon='SELECT_EXTEND')
    self.layout.operator("mesh.select_linked_across_boundaries", icon='LINKED')
    self.layout.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
    self.layout.operator("mesh.merge_by_distance_in_submeshes", icon='AUTOMERGE_ON')
    self.layout.operator("mesh.bake_vertex_vectors", icon='EXPORT')


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
