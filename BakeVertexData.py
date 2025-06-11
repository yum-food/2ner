bl_info = {
    "name": "Bake Vertex to Target Vector",
    "blender": (4, 2, 0),
    "category": "Mesh",
    "version": (2, 3, 0),
    "author": "yum_food",
    "description": "Bake vertex vectors with automatic center and scale calculation in Edit Mode, with submesh deduplication"
}

import bpy
import mathutils
import bmesh
import math
from bpy.props import BoolProperty, FloatProperty, IntProperty, PointerProperty
from bpy.types import Panel, Operator, PropertyGroup
from collections import deque, defaultdict


class BakeVertexSettings(PropertyGroup):
    correction_angle_x: FloatProperty(
        name="X",
        description="Correction angle for the X-axis",
        default=math.pi,
        subtype='ANGLE'
    )
    correction_angle_y: FloatProperty(
        name="Y",
        description="Correction angle for the Y-axis",
        default=0.0,
        subtype='ANGLE'
    )
    correction_angle_z: FloatProperty(
        name="Z",
        description="Correction angle for the Z-axis",
        default=0.0,
        subtype='ANGLE'
    )


class MeshUtils:
    """Utility functions for mesh operations"""

    @staticmethod
    def with_mode(mode):
        """Decorator to handle mode switching"""
        def decorator(func):
            def wrapper(self, context, *args, **kwargs):
                original_mode = context.mode
                if mode == 'OBJECT' and context.mode != 'OBJECT':
                    bpy.ops.object.mode_set(mode='OBJECT')
                elif mode == 'EDIT' and context.mode != 'EDIT_MESH':
                    bpy.ops.object.mode_set(mode='EDIT')

                try:
                    result = func(self, context, *args, **kwargs)
                finally:
                    if original_mode == 'EDIT_MESH' and context.mode != 'EDIT_MESH':
                        bpy.ops.object.mode_set(mode='EDIT')
                    elif original_mode == 'OBJECT' and context.mode != 'OBJECT':
                        bpy.ops.object.mode_set(mode='OBJECT')

                return result
            return wrapper
        return decorator

    @staticmethod
    def with_multi_object_support(process_func_name='process_object'):
        """Decorator to add multi-object support to operators

        The decorated execute method should return a tuple of (success, stats_dict)
        where stats_dict contains the statistics to aggregate across objects.
        """
        def decorator(func):
            def wrapper(self, context, *args, **kwargs):
                # Store the original active object
                original_active = context.active_object

                # Get all selected mesh objects
                selected_objects = [obj for obj in context.selected_objects if obj.type == 'MESH']
                if not selected_objects:
                    self.report({'WARNING'}, "No mesh objects selected")
                    return {'CANCELLED'}

                # Initialize aggregated stats
                total_stats = {}
                processed_count = 0

                # Process each selected object
                for obj in selected_objects:
                    # Make this object active temporarily
                    context.view_layer.objects.active = obj

                    # Call the actual processing method
                    if hasattr(self, process_func_name):
                        success, stats = getattr(self, process_func_name)(context, obj)
                    else:
                        # Fallback to calling the decorated function
                        result = func(self, context, obj, *args, **kwargs)
                        if isinstance(result, tuple) and len(result) == 2:
                            success, stats = result
                        else:
                            success, stats = (result == {'FINISHED'}), {}

                    if success:
                        processed_count += 1
                        # Aggregate statistics
                        for key, value in stats.items():
                            if isinstance(value, (int, float)):
                                total_stats[key] = total_stats.get(key, 0) + value
                            else:
                                # For non-numeric values, just store the last one
                                total_stats[key] = value

                # Restore original active object
                context.view_layer.objects.active = original_active

                # Report results
                total_stats['object_count'] = processed_count
                if hasattr(self, 'format_report'):
                    message = self.format_report(total_stats)
                else:
                    # Default reporting
                    if processed_count == 0:
                        self.report({'WARNING'}, "No objects processed")
                        return {'CANCELLED'}
                    message = f"Processed {processed_count} object(s)"

                if message:
                    self.report({'INFO'}, message)

                return {'FINISHED'}
            return wrapper
        return decorator

    @staticmethod
    def get_selected_vertices(mesh):
        """Get indices of selected vertices"""
        return {v.index for v in mesh.vertices if v.select}

    @staticmethod
    def build_adjacency(mesh, vertex_indices):
        """Build adjacency list for given vertices"""
        adjacency = {idx: set() for idx in vertex_indices}
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if v0 in adjacency and v1 in adjacency:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)
        return adjacency

    @staticmethod
    def flood_fill(start_nodes, adjacency_func):
        """Generic flood fill algorithm"""
        visited = set()
        result = set()
        queue = deque(start_nodes)

        while queue:
            current = queue.popleft()
            if current in visited:
                continue
            visited.add(current)
            result.add(current)

            for neighbor in adjacency_func(current):
                if neighbor not in visited:
                    queue.append(neighbor)

        return result

    @staticmethod
    def find_islands(nodes, adjacency_func):
        """Find connected components"""
        islands = []
        visited = set()

        for node in nodes:
            if node in visited:
                continue

            island = MeshUtils.flood_fill([node], lambda n: adjacency_func.get(n, []))
            visited.update(island)
            islands.append(island)

        return islands

    @staticmethod
    def select_edges_and_faces(mesh):
        """Select edges and faces based on selected vertices"""
        for edge in mesh.edges:
            v0, v1 = edge.vertices
            if mesh.vertices[v0].select and mesh.vertices[v1].select:
                edge.select = True

        for face in mesh.polygons:
            if all(mesh.vertices[v].select for v in face.vertices):
                face.select = True


class BaseSubmeshOperator(Operator):
    """Base class for submesh operations"""
    bl_options = {'REGISTER', 'UNDO'}

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return obj and obj.type == 'MESH' and context.mode == 'EDIT_MESH'

    def get_selected_submeshes(self, mesh):
        """Get selected vertices grouped by submesh"""
        selected = MeshUtils.get_selected_vertices(mesh)
        if not selected:
            return []
        adjacency = MeshUtils.build_adjacency(mesh, selected)
        return MeshUtils.find_islands(selected, adjacency)


class MESH_OT_select_all_linked(BaseSubmeshOperator):
    bl_idname = "mesh.select_all_linked"
    bl_label = "Select All Linked Submeshes"
    bl_description = "Select all vertices in any submesh that has at least one vertex selected"

    def process_object(self, context, obj):
        """Process a single object and return (success, stats)"""
        mesh = obj.data
        initially_selected = MeshUtils.get_selected_vertices(mesh)

        if not initially_selected:
            return False, {}

        all_vertices = set(range(len(mesh.vertices)))
        adjacency = MeshUtils.build_adjacency(mesh, all_vertices)
        islands = MeshUtils.find_islands(all_vertices, adjacency)

        expanded_count = 0
        affected_islands = 0

        for island in islands:
            if island & initially_selected:
                new_selections = island - initially_selected
                if new_selections:
                    expanded_count += len(new_selections)
                    affected_islands += 1
                for idx in island:
                    mesh.vertices[idx].select = True

        MeshUtils.select_edges_and_faces(mesh)

        return True, {
            'affected_islands': affected_islands,
            'expanded_count': expanded_count
        }

    def format_report(self, stats):
        """Format the aggregated statistics into a report message"""
        if stats['object_count'] == 0:
            return "No objects with selected vertices found"
        return f"Expanded selection in {stats['affected_islands']} submeshes ({stats['expanded_count']} new vertices) across {stats['object_count']} object(s)"

    @MeshUtils.with_mode('OBJECT')
    @MeshUtils.with_multi_object_support('process_object')
    def execute(self, context):
        # The decorator handles everything
        pass


class MESH_OT_select_linked_across_boundaries(BaseSubmeshOperator):
    bl_idname = "mesh.select_linked_across_boundaries"
    bl_label = "Select Linked (Cross Boundaries)"
    bl_description = "Select linked vertices, crossing submesh boundaries where vertices share locations"

    epsilon: FloatProperty(
        name="Location Tolerance",
        description="Maximum distance for vertices to be considered at the same location",
        default=0.0001,
        min=0.0,
        max=1.0,
        precision=6,
        subtype='DISTANCE'
    )

    def build_combined_adjacency(self, mesh):
        """Build adjacency including both edges and position-based connections"""
        edge_adjacency = MeshUtils.build_adjacency(mesh, set(range(len(mesh.vertices))))

        # Build position adjacency
        scale = min(1.0 / self.epsilon, 1e7) if self.epsilon > 0 else 1e7
        position_map = defaultdict(list)

        for v in mesh.vertices:
            key = tuple(int(v.co[i] * scale) for i in range(3))
            position_map[key].append(v.index)

        position_adjacency = {}
        for vertices_at_pos in position_map.values():
            if len(vertices_at_pos) > 1:
                for i, v1 in enumerate(vertices_at_pos):
                    if v1 not in position_adjacency:
                        position_adjacency[v1] = set()
                    position_adjacency[v1].update(vertices_at_pos[i+1:])
                    for v2 in vertices_at_pos[i+1:]:
                        if v2 not in position_adjacency:
                            position_adjacency[v2] = set()
                        position_adjacency[v2].add(v1)

        # Combine adjacencies
        def combined_adjacency(vertex):
            neighbors = set()
            if vertex in edge_adjacency:
                neighbors.update(edge_adjacency[vertex])
            if vertex in position_adjacency:
                neighbors.update(position_adjacency[vertex])
            return neighbors

        return combined_adjacency

    def process_object(self, context, obj):
        """Process a single object and return (success, stats)"""
        mesh = obj.data
        initially_selected = MeshUtils.get_selected_vertices(mesh)

        if not initially_selected:
            return False, {}

        combined_adjacency = self.build_combined_adjacency(mesh)
        visited = MeshUtils.flood_fill(initially_selected, combined_adjacency)

        for idx in visited:
            mesh.vertices[idx].select = True

        MeshUtils.select_edges_and_faces(mesh)
        expanded_count = len(visited) - len(initially_selected)

        return True, {
            'selected': len(visited),
            'expanded': expanded_count
        }

    def format_report(self, stats):
        """Format the aggregated statistics into a report message"""
        if stats['object_count'] == 0:
            return "No objects with selected vertices found"
        return f"Selected {stats['selected']} vertices ({stats['expanded']} new) across {stats['object_count']} object(s)"

    @MeshUtils.with_mode('OBJECT')
    @MeshUtils.with_multi_object_support('process_object')
    def execute(self, context):
        # The decorator handles everything
        pass

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "epsilon")
        layout.label(text="Connects vertices at same location", icon='INFO')


class MESH_OT_deduplicate_submeshes(BaseSubmeshOperator):
    bl_idname = "mesh.deduplicate_submeshes"
    bl_label = "Deduplicate Submeshes"
    bl_description = "Remove duplicate submeshes from selection that have vertices at the same locations"

    tolerance: FloatProperty(
        name="Position Tolerance",
        description="Maximum distance for vertices to be considered at the same position",
        default=0.0001,
        min=0.0,
        max=1.0,
        precision=6
    )

    def get_island_signature(self, mesh, island_indices):
        """Create a hash for an island based on vertex positions"""
        decimal_places = 6 if self.tolerance == 0 else max(0, int(-math.log10(self.tolerance)))

        positions = []
        for idx in island_indices:
            co = mesh.vertices[idx].co
            rounded = tuple(round(co[i], decimal_places) for i in range(3))
            positions.append(rounded)

        positions.sort()
        return tuple(positions)

    def process_object(self, context, obj):
        """Process a single object and return (success, stats)"""
        mesh = obj.data
        islands = self.get_selected_submeshes(mesh)

        if len(islands) <= 1:
            return False, {}

        # Group islands by signature
        island_groups = defaultdict(list)
        for island in islands:
            signature = self.get_island_signature(mesh, island)
            island_groups[signature].append(island)

        # Find duplicates to remove
        vertices_to_delete = set()
        duplicate_count = 0

        for group in island_groups.values():
            if len(group) > 1:
                for island in group[1:]:
                    vertices_to_delete.update(island)
                    duplicate_count += 1

        if not vertices_to_delete:
            return False, {}

        # Select vertices to delete
        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.select_all(action='DESELECT')
        bpy.ops.object.mode_set(mode='OBJECT')

        for idx in vertices_to_delete:
            mesh.vertices[idx].select = True

        bpy.ops.object.mode_set(mode='EDIT')
        bpy.ops.mesh.delete(type='VERT')
        bpy.ops.object.mode_set(mode='OBJECT')

        return True, {
            'duplicates': duplicate_count,
            'vertices_deleted': len(vertices_to_delete)
        }

    def format_report(self, stats):
        """Format the aggregated statistics into a report message"""
        if stats['object_count'] == 0:
            return "No duplicate submeshes found"
        return f"Removed {stats['duplicates']} duplicate submeshes ({stats['vertices_deleted']} vertices) across {stats['object_count']} object(s)"

    @MeshUtils.with_mode('OBJECT')
    @MeshUtils.with_multi_object_support('process_object')
    def execute(self, context):
        # The decorator handles everything
        pass

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "tolerance")
        layout.label(text="Set to 0 for exact matching", icon='INFO')


class MESH_OT_pack_uv_islands_by_submesh_z(BaseSubmeshOperator):
    bl_idname = "mesh.pack_uv_islands_by_submesh_z"
    bl_label = "Pack UV Islands by Submesh Z"
    bl_description = "Pack UV islands vertically sorted by submesh Z position"

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
        description="Maximum number of islands per row",
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
        description="Skip overlap detection for better performance",
        default=False
    )

    @classmethod
    def poll(cls, context):
        obj = context.active_object
        return (obj and obj.type == 'MESH' and 
                context.mode == 'EDIT_MESH' and 
                obj.data.uv_layers.active)

    def get_uv_islands(self, bm, uv_layer):
        """Find all UV islands in the mesh"""
        uv_vert_map = {}
        uv_adjacency = defaultdict(set)

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
                uv_vert_map[uv_key].add(loop.vert.index)

            # Create UV edges
            for i in range(len(face_uvs)):
                j = (i + 1) % len(face_uvs)
                uv_adjacency[face_uvs[i]].add(face_uvs[j])
                uv_adjacency[face_uvs[j]].add(face_uvs[i])

        # Find connected components
        islands = []
        for start_uv in uv_vert_map:
            if any(start_uv in island['uvs'] for island in islands):
                continue

            island_uvs = MeshUtils.flood_fill([start_uv], lambda uv: uv_adjacency.get(uv, []))
            island_vert_indices = set()
            for uv in island_uvs:
                island_vert_indices.update(uv_vert_map[uv])

            islands.append({
                'uvs': island_uvs,
                'vert_indices': island_vert_indices,
                'loops': []
            })

        return islands

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        bm = bmesh.from_edit_mesh(mesh)
        bm_uv_layer = bm.loops.layers.uv.active

        # Get UV islands
        uv_islands = self.get_uv_islands(bm, bm_uv_layer)
        if not uv_islands:
            self.report({'WARNING'}, "No UV islands found")
            return {'CANCELLED'}

        # Get submeshes and their Z values
        bpy.ops.object.mode_set(mode='OBJECT')
        submeshes = self.get_selected_submeshes(mesh)

        submesh_z_values = []
        for submesh in submeshes:
            avg_z = sum(mesh.vertices[idx].co.z for idx in submesh) / len(submesh)
            submesh_z_values.append(avg_z)

        # Build vertex to submesh mapping
        vertex_to_submesh = {}
        for i, submesh in enumerate(submeshes):
            for v in submesh:
                vertex_to_submesh[v] = i

        bpy.ops.object.mode_set(mode='EDIT')
        bm = bmesh.from_edit_mesh(mesh)
        bm_uv_layer = bm.loops.layers.uv.active

        # Build UV to loops mapping
        uv_to_loops = defaultdict(list)
        for face in bm.faces:
            if face.select:
                for loop in face.loops:
                    uv = loop[bm_uv_layer].uv
                    uv_key = (round(uv.x, 6), round(uv.y, 6))
                    uv_to_loops[uv_key].append(loop)

        # Assign loops and create island data
        island_data = []
        for island in uv_islands:
            island['loops'] = []
            for uv_key in island['uvs']:
                island['loops'].extend(uv_to_loops.get(uv_key, []))

            if not island['loops']:
                continue

            # Find submesh
            submesh_idx = None
            for v_idx in island['vert_indices']:
                if v_idx in vertex_to_submesh:
                    submesh_idx = vertex_to_submesh[v_idx]
                    break

            if submesh_idx is not None:
                # Get bounds
                min_u = min_v = float('inf')
                max_u = max_v = float('-inf')

                for loop in island['loops']:
                    uv = loop[bm_uv_layer].uv
                    min_u = min(min_u, uv.x)
                    max_u = max(max_u, uv.x)
                    min_v = min(min_v, uv.y)
                    max_v = max(max_v, uv.y)

                width = max_u - min_u
                height = max_v - min_v

                if width > 0 and height > 0:
                    island_data.append({
                        'island': island,
                        'submesh_z': submesh_z_values[submesh_idx],
                        'bounds': (min_u, min_v, max_u, max_v),
                        'width': width,
                        'height': height
                    })

        # Sort by submesh Z
        island_data.sort(key=lambda x: x['submesh_z'], reverse=True)

        # Calculate scale
        total_area = sum((d['width'] + self.padding) * (d['height'] + self.padding) 
                        for d in island_data)
        target_size = min(0.95, math.sqrt(total_area) * 1.2)
        scale_factor = 0.95 / target_size if target_size > 1.0 else 1.0

        # Pack islands
        current_v = 0.95
        current_row = []

        for data in island_data:
            width = data['width'] * scale_factor
            height = data['height'] * scale_factor

            # Start new row if needed
            if current_row and (sum(d['width'] * scale_factor + self.padding for d in current_row) + width > target_size 
                               or len(current_row) >= self.max_islands_per_row):
                # Place current row
                current_u = 0.025
                row_height = max(d['height'] * scale_factor for d in current_row)

                for row_data in current_row:
                    offset_u = current_u - row_data['bounds'][0] * scale_factor
                    offset_v = current_v - row_data['bounds'][3] * scale_factor

                    for loop in row_data['island']['loops']:
                        uv = loop[bm_uv_layer].uv
                        uv.x = uv.x * scale_factor + offset_u
                        uv.y = uv.y * scale_factor + offset_v

                    current_u += row_data['width'] * scale_factor + self.padding

                current_v -= row_height + self.padding
                current_row = []

            current_row.append(data)

        # Place final row
        if current_row:
            current_u = 0.025
            for row_data in current_row:
                offset_u = current_u - row_data['bounds'][0] * scale_factor
                offset_v = current_v - row_data['bounds'][3] * scale_factor

                for loop in row_data['island']['loops']:
                    uv = loop[bm_uv_layer].uv
                    uv.x = uv.x * scale_factor + offset_u
                    uv.y = uv.y * scale_factor + offset_v

                current_u += row_data['width'] * scale_factor + self.padding

        bmesh.update_edit_mesh(mesh)
        self.report({'INFO'}, f"Packed {len(island_data)} UV islands from {len(submeshes)} submeshes")
        return {'FINISHED'}

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "padding")
        layout.prop(self, "max_islands_per_row")
        layout.prop(self, "lock_overlapping")
        layout.prop(self, "skip_overlap_check")


class MESH_OT_merge_by_distance_per_submesh(BaseSubmeshOperator):
    bl_idname = "mesh.merge_by_distance_per_submesh"
    bl_label = "Merge by Distance (Per Submesh)"
    bl_description = "Merge vertices by distance within each submesh separately"

    merge_distance: FloatProperty(
        name="Merge Distance",
        description="Maximum distance for merging vertices",
        default=0.001,
        min=0.0,
        max=1.0,
        precision=6,
        subtype='DISTANCE'
    )

    def process_object(self, context, obj):
        """Process a single object and return (success, stats)"""
        mesh = obj.data
        bm = bmesh.from_edit_mesh(mesh)

        selected_verts = [v for v in bm.verts if v.select]
        if not selected_verts:
            return False, {}

        # Build islands using BMesh
        selected_set = set(selected_verts)
        island_verts = []
        visited = set()

        for start_v in selected_verts:
            if start_v in visited:
                continue

            # Find island
            island = []
            stack = [start_v]

            while stack:
                current = stack.pop()
                if current in visited:
                    continue
                visited.add(current)
                island.append(current)

                for edge in current.link_edges:
                    other = edge.other_vert(current)
                    if other in selected_set and other not in visited:
                        stack.append(other)

            island_verts.append(island)

        # Merge within each island
        merge_targets = {}
        merge_dist_sq = self.merge_distance ** 2
        merged_count = 0

        for verts in island_verts:
            if len(verts) < 2:
                continue

            processed = set()
            for i, v1 in enumerate(verts):
                if v1 in merge_targets or v1 in processed:
                    continue
                processed.add(v1)

                for v2 in verts[i+1:]:
                    if v2 in merge_targets or v2 in processed:
                        continue

                    if (v1.co - v2.co).length_squared <= merge_dist_sq:
                        merge_targets[v2] = v1
                        processed.add(v2)
                        merged_count += 1

        # Perform merges
        if merge_targets:
            targetmap = {v: merge_targets[v] for v in merge_targets if v.is_valid}
            if targetmap:
                bmesh.ops.weld_verts(bm, targetmap=targetmap)

        bmesh.update_edit_mesh(mesh)

        return merged_count > 0, {'merged': merged_count}

    def format_report(self, stats):
        """Format the aggregated statistics into a report message"""
        if stats.get('merged', 0) > 0:
            return f"Merged {stats['merged']} vertices across {stats['object_count']} object(s)"
        else:
            return "No vertices close enough to merge"

    @MeshUtils.with_multi_object_support('process_object')
    def execute(self, context):
        # The decorator handles everything
        pass

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "merge_distance")


class MESH_OT_bake_vertex_and_rotation_combined(BaseSubmeshOperator):
    bl_idname = "mesh.bake_submesh_origin_and_orientation"
    bl_label = "Bake Submesh Data"
    bl_description = "Bake vertex vectors and orientation quaternions"

    contiguous_mode: BoolProperty(
        name="Contiguous Groups",
        description="Process each contiguous group separately",
        default=True
    )

    normal_epsilon: FloatProperty(
        name="Normal Epsilon",
        description="Minimum angle difference between normals",
        default=0.1,
        min=0.01,
        max=1.0,
        precision=3
    )

    use_cache: BoolProperty(
        name="Cache Identical Submeshes",
        description="Cache calculations for identical submeshes",
        default=True
    )

    def calculate_island_data(self, mesh, island_indices):
        """Calculate center and scale for an island"""
        if not island_indices:
            return None, 1.0

        center = mathutils.Vector((0.0, 0.0, 0.0))
        for idx in island_indices:
            center += mesh.vertices[idx].co
        center /= len(island_indices)

        max_dist = max((abs(c - center[i]) 
                       for idx in island_indices 
                       for i, c in enumerate(mesh.vertices[idx].co)), 
                      default=0)

        scale = 1.0 / max_dist if max_dist > 0 else 1.0
        return center, scale

    def build_basis_from_faces(self, mesh, face_indices, epsilon):
        """Build orthonormal basis from face normals"""
        if not face_indices:
            return mathutils.Matrix.Identity(3)

        # Get largest face normal
        faces = sorted(face_indices, key=lambda i: mesh.polygons[i].area, reverse=True)
        x_axis = mesh.polygons[faces[0]].normal.normalized()

        # Find second normal
        epsilon_cos = math.cos(epsilon)
        y_axis = None

        for face_idx in faces[1:]:
            normal = mesh.polygons[face_idx].normal.normalized()
            if abs(normal.dot(x_axis)) < epsilon_cos:
                y_axis = normal - normal.dot(x_axis) * x_axis
                y_axis.normalize()
                break

        if not y_axis:
            if abs(x_axis.z) < 0.9:
                y_axis = mathutils.Vector((-x_axis.y, x_axis.x, 0))
            else:
                y_axis = mathutils.Vector((0, -x_axis.z, x_axis.y))
            y_axis.normalize()

        z_axis = x_axis.cross(y_axis)

        matrix = mathutils.Matrix((x_axis, y_axis, z_axis)).transposed()
        if matrix.determinant() < 0:
            matrix[2] = -matrix[2]

        return matrix

    def create_submesh_signature(self, mesh, island_indices, center, scale):
        """Create signature for caching"""
        tolerance = 0.0001
        local_positions = []

        for idx in island_indices:
            local_pos = (mesh.vertices[idx].co - center) * scale
            rounded = tuple(round(local_pos[i] / tolerance) * tolerance for i in range(3))
            local_positions.append(rounded)

        local_positions.sort()
        return (len(island_indices), tuple(local_positions))

    def process_object(self, context, obj):
        """Process a single object and return (success, stats)"""
        mesh = obj.data
        selected = MeshUtils.get_selected_vertices(mesh)

        if not selected:
            return False, {}

        # Create/get data layers
        if not mesh.vertex_colors:
            mesh.vertex_colors.new(name="BakedVectors")
        color_layer = mesh.vertex_colors.active

        uv_layer0 = mesh.uv_layers.get("BakedOriginAngle0") or mesh.uv_layers.new(name="BakedOriginAngle0")
        uv_layer1 = mesh.uv_layers.get("BakedOriginAngle1") or mesh.uv_layers.new(name="BakedOriginAngle1")

        # Get correction quaternion
        settings = context.scene.bake_vertex_settings
        correction = mathutils.Euler(
            (settings.correction_angle_x, settings.correction_angle_y, settings.correction_angle_z), 'XYZ'
        ).to_quaternion()

        # Build vertex to loops mapping
        vertex_loops = defaultdict(list)
        selected_faces = []

        for poly in mesh.polygons:
            face_verts = set(poly.vertices)
            if face_verts & selected:
                if face_verts <= selected:
                    selected_faces.append(poly.index)

                for loop_idx in poly.loop_indices:
                    vert_idx = mesh.loops[loop_idx].vertex_index
                    if vert_idx in selected:
                        vertex_loops[vert_idx].append(loop_idx)

        # Get islands
        islands = self.get_selected_submeshes(mesh) if self.contiguous_mode else [selected]

        # Process each island
        world_matrix = obj.matrix_world
        world_inv = world_matrix.inverted()
        submesh_cache = {} if self.use_cache else None

        for island in islands:
            center, scale = self.calculate_island_data(mesh, island)
            if center is None:
                continue

            # Check cache
            if self.use_cache:
                signature = self.create_submesh_signature(mesh, island, center, scale)
                if signature in submesh_cache:
                    scale, basis, quat, basis_inv = submesh_cache[signature]
                else:
                    island_faces = [f for f in selected_faces 
                                  if all(v in island for v in mesh.polygons[f].vertices)]
                    basis = self.build_basis_from_faces(mesh, island_faces, self.normal_epsilon)
                    quat = basis.to_quaternion()
                    quat.normalize()
                    if quat.w < 0:
                        quat.negate()
                    quat = correction @ quat
                    basis_inv = basis.inverted()

                    submesh_cache[signature] = (scale, basis, quat, basis_inv)
            else:
                island_faces = [f for f in selected_faces 
                              if all(v in island for v in mesh.polygons[f].vertices)]
                basis = self.build_basis_from_faces(mesh, island_faces, self.normal_epsilon)
                quat = basis.to_quaternion()
                quat.normalize()
                if quat.w < 0:
                    quat.negate()
                quat = correction @ quat
                basis_inv = basis.inverted()

            # Transform vertices
            center_world = world_matrix @ center

            for vert_idx in island:
                vert_world = world_matrix @ mesh.vertices[vert_idx].co
                offset = world_inv.to_3x3() @ (vert_world - center_world)
                local_pos = basis_inv @ offset

                # Scale and convert to color
                color = mathutils.Vector((
                    (local_pos.x * scale + 1.0) * 0.5,
                    (local_pos.y * scale + 1.0) * 0.5,
                    (local_pos.z * scale + 1.0) * 0.5,
                    scale
                ))

                # Apply to loops
                for loop_idx in vertex_loops.get(vert_idx, []):
                    color_layer.data[loop_idx].color = color
                    uv_layer0.data[loop_idx].uv = (quat.x, quat.y)
                    uv_layer1.data[loop_idx].uv = (quat.z, quat.w)

        mesh.update()

        return True, {
            'islands': len(islands),
            'vertices': len(selected)
        }

    def format_report(self, stats):
        """Format the aggregated statistics into a report message"""
        if stats['object_count'] == 0:
            return "No objects with selected vertices found"
        return f"Baked {stats['islands']} island(s) with {stats['vertices']} vertices across {stats['object_count']} object(s)"

    @MeshUtils.with_mode('OBJECT')
    @MeshUtils.with_multi_object_support('process_object')
    def execute(self, context):
        # The decorator handles everything
        pass

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "contiguous_mode")
        layout.prop(self, "use_cache")
        layout.prop(self, "normal_epsilon")

        settings = context.scene.bake_vertex_settings
        box = layout.box()
        box.label(text="Bake Rotation Correction (Degrees)")
        row = box.row(align=True)
        row.prop(settings, "correction_angle_x")
        row.prop(settings, "correction_angle_y")
        row.prop(settings, "correction_angle_z")


class MESH_PT_bake_vertex_panel(Panel):
    bl_label = "Bake Submesh Data"
    bl_idname = "MESH_PT_bake_submesh_data"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = "Tool"

    def draw(self, context):
        layout = self.layout
        obj = context.active_object

        if obj and obj.type == 'MESH' and context.mode == 'EDIT_MESH':
            col = layout.column()
            col.operator("mesh.bake_submesh_origin_and_orientation", icon='EXPORT')
            col.operator("mesh.select_all_linked", icon='SELECT_EXTEND')
            col.operator("mesh.select_linked_across_boundaries", icon='LINKED')
            col.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
            col.operator("mesh.merge_by_distance_per_submesh", icon='AUTOMERGE_ON')
            col.operator("mesh.pack_uv_islands_by_submesh_z", icon='UV')
        else:
            layout.label(text="Enter Edit Mode to use tools", icon='INFO')


classes = [
    BakeVertexSettings,
    MESH_OT_select_all_linked,
    MESH_OT_select_linked_across_boundaries,
    MESH_OT_deduplicate_submeshes,
    MESH_OT_pack_uv_islands_by_submesh_z,
    MESH_OT_merge_by_distance_per_submesh,
    MESH_OT_bake_vertex_and_rotation_combined,
    MESH_PT_bake_vertex_panel
]


def menu_func(self, context):
    self.layout.separator()
    self.layout.operator("mesh.select_all_linked", icon='SELECT_EXTEND')
    self.layout.operator("mesh.select_linked_across_boundaries", icon='LINKED')
    self.layout.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
    self.layout.operator("mesh.merge_by_distance_per_submesh", icon='AUTOMERGE_ON')
    self.layout.operator("mesh.pack_uv_islands_by_submesh_z", icon='UV')
    self.layout.operator("mesh.bake_submesh_origin_and_orientation", icon='EXPORT')


def register():
    for cls in classes:
        bpy.utils.register_class(cls)
    bpy.types.VIEW3D_MT_edit_mesh.append(menu_func)
    bpy.types.Scene.bake_vertex_settings = PointerProperty(type=BakeVertexSettings)


def unregister():
    bpy.types.VIEW3D_MT_edit_mesh.remove(menu_func)
    del bpy.types.Scene.bake_vertex_settings
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)


if __name__ == "__main__":
    register()
