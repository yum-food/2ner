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
        """Decorator to add multi-object support to operators"""
        def decorator(func):
            def wrapper(self, context, *args, **kwargs):
                original_active = context.active_object
                selected_objects = [obj for obj in context.selected_objects if obj.type == 'MESH']
                
                if not selected_objects:
                    self.report({'WARNING'}, "No mesh objects selected")
                    return {'CANCELLED'}

                total_stats = {}
                processed_count = 0

                for obj in selected_objects:
                    context.view_layer.objects.active = obj

                    if hasattr(self, process_func_name):
                        success, stats = getattr(self, process_func_name)(context, obj)
                    else:
                        result = func(self, context, obj, *args, **kwargs)
                        if isinstance(result, tuple) and len(result) == 2:
                            success, stats = result
                        else:
                            success, stats = (result == {'FINISHED'}), {}

                    if success:
                        processed_count += 1
                        for key, value in stats.items():
                            if isinstance(value, (int, float)):
                                total_stats[key] = total_stats.get(key, 0) + value
                            else:
                                total_stats[key] = value

                context.view_layer.objects.active = original_active

                total_stats['object_count'] = processed_count
                if hasattr(self, 'format_report'):
                    message = self.format_report(total_stats)
                else:
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

    @staticmethod
    def build_position_map(vertices, scale):
        """Build a map of vertices by quantized position"""
        position_map = defaultdict(list)
        for v in vertices:
            if hasattr(v, 'index'):
                key = tuple(int(v.co[i] * scale) for i in range(3))
                position_map[key].append(v.index)
            else:
                key = tuple(int(v[i] * scale) for i in range(3))
                position_map[key].append(v)
        return position_map

    @staticmethod
    def get_or_create_uv_layer(mesh, name):
        """Get or create a UV layer by name"""
        return mesh.uv_layers.get(name) or mesh.uv_layers.new(name=name)


class BaseSubmeshOperator(Operator):
    """Base class for submesh operations with common functionality"""
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

    @MeshUtils.with_multi_object_support('process_object')
    def execute(self, context):
        pass


class ToleranceOperatorMixin:
    """Mixin for operators that use tolerance values"""
    
    def get_scale_from_tolerance(self, tolerance):
        """Convert tolerance to scale factor for quantization"""
        return min(1.0 / tolerance, 1e7) if tolerance > 0 else 1e7


class MESH_OT_select_all_linked(BaseSubmeshOperator):
    bl_idname = "mesh.select_all_linked"
    bl_label = "Select All Linked Submeshes"
    bl_description = "Select all vertices in any submesh that has at least one vertex selected"

    def process_object(self, context, obj):
        mesh = obj.data
        
        # Get BMesh for edit mode operations
        bm = bmesh.from_edit_mesh(mesh)
        bm.verts.ensure_lookup_table()
        
        initially_selected = {v.index for v in bm.verts if v.select}

        if not initially_selected:
            return False, {}

        # Build adjacency using BMesh
        all_vertices = set(range(len(bm.verts)))
        adjacency = {idx: set() for idx in all_vertices}
        
        for edge in bm.edges:
            v0, v1 = edge.verts[0].index, edge.verts[1].index
            adjacency[v0].add(v1)
            adjacency[v1].add(v0)
        
        islands = MeshUtils.find_islands(all_vertices, adjacency)

        expanded_count = 0
        affected_islands = 0

        for island in islands:
            if island & initially_selected:
                new_selections = island - initially_selected
                if new_selections:
                    expanded_count += len(new_selections)
                    affected_islands += 1
                # Select all vertices in the island using BMesh
                for idx in island:
                    bm.verts[idx].select = True

        # Select edges and faces based on selected vertices
        for edge in bm.edges:
            if edge.verts[0].select and edge.verts[1].select:
                edge.select = True

        for face in bm.faces:
            if all(v.select for v in face.verts):
                face.select = True

        # Update the mesh
        bmesh.update_edit_mesh(mesh)

        return True, {
            'affected_islands': affected_islands,
            'expanded_count': expanded_count
        }

    def format_report(self, stats):
        if stats['object_count'] == 0:
            return "No objects with selected vertices found"
        return f"Expanded selection in {stats['affected_islands']} submeshes ({stats['expanded_count']} new vertices) across {stats['object_count']} object(s)"


class MESH_OT_select_linked_across_boundaries(BaseSubmeshOperator, ToleranceOperatorMixin):
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

    def build_combined_adjacency(self, bm):
        """Build adjacency including both edges and position-based connections"""
        # Build edge adjacency
        edge_adjacency = {v.index: set() for v in bm.verts}
        
        for edge in bm.edges:
            v0, v1 = edge.verts[0].index, edge.verts[1].index
            edge_adjacency[v0].add(v1)
            edge_adjacency[v1].add(v0)

        # Build position-based adjacency
        scale = self.get_scale_from_tolerance(self.epsilon)
        position_map = defaultdict(list)
        
        for v in bm.verts:
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

        def combined_adjacency(vertex):
            neighbors = set()
            if vertex in edge_adjacency:
                neighbors.update(edge_adjacency[vertex])
            if vertex in position_adjacency:
                neighbors.update(position_adjacency[vertex])
            return neighbors

        return combined_adjacency

    def process_object(self, context, obj):
        mesh = obj.data
        
        # Get BMesh for edit mode operations
        bm = bmesh.from_edit_mesh(mesh)
        bm.verts.ensure_lookup_table()
        
        initially_selected = {v.index for v in bm.verts if v.select}

        if not initially_selected:
            return False, {}

        combined_adjacency = self.build_combined_adjacency(bm)
        visited = MeshUtils.flood_fill(initially_selected, combined_adjacency)

        # Select vertices using BMesh
        for idx in visited:
            bm.verts[idx].select = True

        # Select edges and faces based on selected vertices
        for edge in bm.edges:
            if edge.verts[0].select and edge.verts[1].select:
                edge.select = True

        for face in bm.faces:
            if all(v.select for v in face.verts):
                face.select = True

        # Update the mesh
        bmesh.update_edit_mesh(mesh)
        
        expanded_count = len(visited) - len(initially_selected)

        return True, {
            'selected': len(visited),
            'expanded': expanded_count
        }

    def format_report(self, stats):
        if stats['object_count'] == 0:
            return "No objects with selected vertices found"
        return f"Selected {stats['selected']} vertices ({stats['expanded']} new) across {stats['object_count']} object(s)"

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "epsilon")
        layout.label(text="Connects vertices at same location", icon='INFO')


class MESH_OT_deduplicate_submeshes(BaseSubmeshOperator, ToleranceOperatorMixin):
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

    def get_island_signature(self, island_verts):
        """Create a hash for an island based on vertex positions"""
        decimal_places = 6 if self.tolerance == 0 else max(0, int(-math.log10(self.tolerance)))

        positions = []
        for v in island_verts:
            co = v.co
            rounded = tuple(round(co[i], decimal_places) for i in range(3))
            positions.append(rounded)

        positions.sort()
        return tuple(positions)

    def process_object(self, context, obj):
        mesh = obj.data
        
        # Get BMesh for edit mode operations
        bm = bmesh.from_edit_mesh(mesh)
        bm.verts.ensure_lookup_table()
        
        # Get selected vertices
        selected_indices = {v.index for v in bm.verts if v.select}
        if not selected_indices:
            return False, {}
        
        # Build adjacency
        adjacency = {idx: set() for idx in selected_indices}
        for edge in bm.edges:
            v0, v1 = edge.verts[0].index, edge.verts[1].index
            if v0 in selected_indices and v1 in selected_indices:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)
        
        # Find islands
        island_indices = MeshUtils.find_islands(selected_indices, adjacency)
        
        if len(island_indices) <= 1:
            return False, {}

        # Create island vertex lists
        islands = []
        for island_idx_set in island_indices:
            island_verts = [bm.verts[idx] for idx in island_idx_set]
            islands.append(island_verts)

        # Group islands by signature
        island_groups = defaultdict(list)
        for island in islands:
            signature = self.get_island_signature(island)
            island_groups[signature].append(island)

        vertices_to_delete = set()
        duplicate_count = 0

        # Mark duplicate islands for deletion
        for group in island_groups.values():
            if len(group) > 1:
                # Keep the first island, delete the rest
                for island in group[1:]:
                    for v in island:
                        vertices_to_delete.add(v)
                    duplicate_count += 1

        if not vertices_to_delete:
            return False, {}

        # Delete vertices using BMesh
        bmesh.ops.delete(bm, geom=list(vertices_to_delete), context='VERTS')
        
        # Update the mesh
        bmesh.update_edit_mesh(mesh)

        return True, {
            'duplicates': duplicate_count,
            'vertices_deleted': len(vertices_to_delete)
        }

    def format_report(self, stats):
        if stats['object_count'] == 0:
            return "No objects processed"
        
        return f"Removed {stats['duplicates']} duplicate submeshes ({stats['vertices_deleted']} vertices) across {stats['object_count']} object(s)"

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "tolerance")
        layout.label(text="Set to 0 for exact matching", icon='INFO')


class MESH_OT_select_hidden_faces(BaseSubmeshOperator, ToleranceOperatorMixin):
    bl_idname = "mesh.select_hidden_faces"
    bl_label = "Select Hidden Faces"
    bl_description = "Select faces that are hidden behind other faces (overlapping with opposing normals and same material)"

    position_tolerance: FloatProperty(
        name="Position Tolerance",
        description="Maximum distance for vertices to be considered at the same position",
        default=0.001,
        min=0.0,
        max=0.1,
        precision=6,
        subtype='DISTANCE'
    )

    normal_tolerance: FloatProperty(
        name="Normal Tolerance",
        description="Maximum angle difference for normals to be considered opposing",
        default=0.1,
        min=0.0,
        max=math.pi,
        precision=3,
        subtype='ANGLE'
    )

    def process_object(self, context, obj):
        mesh = obj.data
        
        # Get BMesh for edit mode operations
        bm = bmesh.from_edit_mesh(mesh)
        bm.faces.ensure_lookup_table()
        
        selected_faces = [f for f in bm.faces if f.select]
        faces_to_check = selected_faces if selected_faces else list(bm.faces)
        
        if len(faces_to_check) < 2:
            return False, {}

        scale = self.get_scale_from_tolerance(self.position_tolerance)
        
        def get_center_hash_variations(center):
            """Get hash variations for a point near grid boundaries"""
            variations = []
            boundary_threshold = 0.1  # If within 10% of grid boundary
            
            # For each dimension, determine which cells to hash to
            cells = []
            for i in range(3):
                scaled = center[i] * scale
                floored = int(scaled)
                frac = scaled - floored
                
                if frac < boundary_threshold:
                    # Near lower boundary, include previous cell
                    cells.append([floored - 1, floored])
                elif frac > (1.0 - boundary_threshold):
                    # Near upper boundary, include next cell
                    cells.append([floored, floored + 1])
                else:
                    # Not near boundary
                    cells.append([floored])
            
            # Generate all combinations (max 8 for a corner)
            for x in cells[0]:
                for y in cells[1]:
                    for z in cells[2]:
                        variations.append((x, y, z))
            
            return variations
        
        def faces_match(face1, face2):
            """Check if two faces have matching vertices at same positions"""
            if len(face1.verts) != len(face2.verts):
                return False
            
            # For each vertex in face1, check if there's a matching vertex in face2
            tolerance_sq = self.position_tolerance * self.position_tolerance
            
            for v1 in face1.verts:
                found_match = False
                for v2 in face2.verts:
                    if (v1.co - v2.co).length_squared <= tolerance_sq:
                        found_match = True
                        break
                if not found_match:
                    return False
            
            return True

        # Group faces by center position for finding candidates
        center_hash_map = defaultdict(list)
        face_data = {}
        
        for face in faces_to_check:
            center = face.calc_center_median()
            
            # Store face data
            face_data[face.index] = {
                'normal': face.normal.normalized(),
                'face': face,
                'center': center,
                'material_index': face.material_index
            }
            
            # Hash by center position (with boundary handling)
            center_variations = get_center_hash_variations(center)
            for center_hash in center_variations:
                center_hash_map[center_hash].append(face.index)

        hidden_faces = set()
        checked_pairs = 0
        checked_face_pairs = set()
        
        # Check faces that have the same center hash
        for center_hash, face_indices in center_hash_map.items():
            if len(face_indices) < 2:
                continue
            
            for i in range(len(face_indices)):
                for j in range(i + 1, len(face_indices)):
                    face1_idx = face_indices[i]
                    face2_idx = face_indices[j]
                    
                    # Skip if we've already checked this pair
                    pair = (min(face1_idx, face2_idx), max(face1_idx, face2_idx))
                    if pair in checked_face_pairs:
                        continue
                    checked_face_pairs.add(pair)
                    
                    face1_data = face_data[face1_idx]
                    face2_data = face_data[face2_idx]
                    
                    # Check if faces use the same material
                    if face1_data['material_index'] != face2_data['material_index']:
                        continue
                    
                    # Quick check: opposing normals
                    dot_product = face1_data['normal'].dot(face2_data['normal'])
                    if dot_product >= 0:
                        continue
                    
                    # Check angle tolerance
                    angle_diff = math.acos(min(1.0, max(-1.0, abs(dot_product))))
                    if angle_diff >= self.normal_tolerance:
                        continue
                    
                    # Detailed vertex comparison
                    checked_pairs += 1
                    if faces_match(face1_data['face'], face2_data['face']):
                        hidden_faces.add(face1_idx)
                        hidden_faces.add(face2_idx)
        
        # Select faces using BMesh
        for face_idx in hidden_faces:
            if face_idx in face_data:
                face_data[face_idx]['face'].select = True
        
        # Update the mesh
        bmesh.update_edit_mesh(mesh)
        
        return len(hidden_faces) > 0, {
            'hidden_faces': len(hidden_faces),
            'checked_faces': len(faces_to_check),
            'checked_pairs': checked_pairs,
            'hash_groups': len([g for g in center_hash_map.values() if len(g) > 1])
        }

    def format_report(self, stats):
        if stats['object_count'] == 0:
            return "No objects processed"
        if stats['hidden_faces'] == 0:
            groups = stats.get('hash_groups', 0)
            pairs = stats.get('checked_pairs', 0)
            return f"No hidden faces found among {stats['checked_faces']} faces ({groups} overlapping groups, {pairs} pairs checked) in {stats['object_count']} object(s)"
        
        groups = stats.get('hash_groups', 0)
        pairs = stats.get('checked_pairs', 0)
        return f"Selected {stats['hidden_faces']} hidden faces from {stats['checked_faces']} faces ({groups} overlapping groups, {pairs} pairs checked) across {stats['object_count']} object(s)"

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "position_tolerance")
        layout.prop(self, "normal_tolerance")
        layout.label(text="Selects overlapping faces with opposing normals", icon='INFO')
        layout.label(text="Only considers faces with the same material", icon='INFO')


class UVOperatorMixin:
    """Mixin for UV-related operations"""
    
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

            for i in range(len(face_uvs)):
                j = (i + 1) % len(face_uvs)
                uv_adjacency[face_uvs[i]].add(face_uvs[j])
                uv_adjacency[face_uvs[j]].add(face_uvs[i])

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


class MESH_OT_pack_uv_islands_by_submesh_z(BaseSubmeshOperator, UVOperatorMixin):
    bl_idname = "mesh.pack_uv_islands_by_submesh_z"
    bl_label = "Pack UV Islands by Submesh Z"
    bl_description = "Pack UV islands vertically sorted by submesh Z position"

    padding: FloatProperty(
        name="Island Padding (px)",
        description="Padding between UV islands (in pixels, evaluated against the current render resolution). A value of 4.0 yields ~4 pixels of gap in the final packed result.",
        default=4.0,
        min=0.0,
        max=256.0,
        precision=1
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

    def execute(self, context):
        obj = context.active_object
        mesh = obj.data

        # Get BMesh and ensure we have a UV layer
        bm = bmesh.from_edit_mesh(mesh)
        bm.verts.ensure_lookup_table()
        bm.faces.ensure_lookup_table()
        
        if not bm.loops.layers.uv:
            self.report({'WARNING'}, "No UV layer found")
            return {'CANCELLED'}
            
        bm_uv_layer = bm.loops.layers.uv.active

        # Get UV islands
        uv_islands = self.get_uv_islands(bm, bm_uv_layer)
        if not uv_islands:
            self.report({'WARNING'}, "No UV islands found")
            return {'CANCELLED'}

        # Get selected vertices and build submeshes
        selected_indices = {v.index for v in bm.verts if v.select}
        if not selected_indices:
            self.report({'WARNING'}, "No vertices selected")
            return {'CANCELLED'}
            
        # Build adjacency
        adjacency = {idx: set() for idx in selected_indices}
        for edge in bm.edges:
            v0, v1 = edge.verts[0].index, edge.verts[1].index
            if v0 in selected_indices and v1 in selected_indices:
                adjacency[v0].add(v1)
                adjacency[v1].add(v0)
        
        # Find submeshes
        submesh_indices = MeshUtils.find_islands(selected_indices, adjacency)
        
        # Calculate average Z for each submesh
        submesh_z_values = []
        for submesh_idx_set in submesh_indices:
            avg_z = sum(bm.verts[idx].co.z for idx in submesh_idx_set) / len(submesh_idx_set)
            submesh_z_values.append(avg_z)

        # Map vertices to submeshes
        vertex_to_submesh = {}
        for i, submesh_idx_set in enumerate(submesh_indices):
            for v_idx in submesh_idx_set:
                vertex_to_submesh[v_idx] = i

        # Build UV to loops mapping
        uv_to_loops = defaultdict(list)
        for face in bm.faces:
            if face.select:
                for loop in face.loops:
                    uv = loop[bm_uv_layer].uv
                    uv_key = (round(uv.x, 6), round(uv.y, 6))
                    uv_to_loops[uv_key].append(loop)

        # Process islands
        island_data = []
        for island in uv_islands:
            island['loops'] = []
            for uv_key in island['uvs']:
                island['loops'].extend(uv_to_loops.get(uv_key, []))

            if not island['loops']:
                continue

            # Find submesh for this island
            submesh_idx = None
            for v_idx in island['vert_indices']:
                if v_idx in vertex_to_submesh:
                    submesh_idx = vertex_to_submesh[v_idx]
                    break

            if submesh_idx is not None:
                # Calculate bounds
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

        # Sort by Z position
        island_data.sort(key=lambda x: x['submesh_z'], reverse=True)

        # Pack islands
        # Convert pixel padding to UV units based on render resolution (largest axis)
        render = context.scene.render
        tex_size = max(
            render.resolution_x * render.resolution_percentage / 100.0,
            render.resolution_y * render.resolution_percentage / 100.0,
        ) or 1024.0  # Fallback to 1024 if resolution is unset/zero

        padding_uv = self.padding / tex_size

        total_area = sum(
            (d['width'] + padding_uv) * (d['height'] + padding_uv)
            for d in island_data
        )
        target_size = min(0.95, math.sqrt(total_area) * 1.2)
        scale_factor = 0.95 / target_size if target_size > 1.0 else 1.0

        current_v = 0.95
        current_row = []

        for data in island_data:
            width = data['width'] * scale_factor
            height = data['height'] * scale_factor

            padding_scaled = padding_uv * scale_factor

            # Check if we need to start a new row
            if current_row and (
                sum(d['width'] * scale_factor + padding_scaled for d in current_row) + width > target_size
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

                    current_u += row_data['width'] * scale_factor + padding_scaled

                current_v -= row_height + padding_scaled
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

                current_u += row_data['width'] * scale_factor + padding_scaled

        # Update the mesh
        bmesh.update_edit_mesh(mesh)
        
        self.report({'INFO'}, f"Packed {len(island_data)} UV islands from {len(submesh_indices)} submeshes")
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
        mesh = obj.data
        bm = bmesh.from_edit_mesh(mesh)
        bm.verts.ensure_lookup_table()

        selected_verts = [v for v in bm.verts if v.select]
        if not selected_verts:
            return False, {}

        selected_set = set(selected_verts)
        island_verts = []
        visited = set()

        for start_v in selected_verts:
            if start_v in visited:
                continue

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

        if merge_targets:
            targetmap = {v: merge_targets[v] for v in merge_targets if v.is_valid}
            if targetmap:
                bmesh.ops.weld_verts(bm, targetmap=targetmap)

        bmesh.update_edit_mesh(mesh)

        return merged_count > 0, {'merged': merged_count}

    def format_report(self, stats):
        if stats.get('merged', 0) > 0:
            return f"Merged {stats['merged']} vertices across {stats['object_count']} object(s)"
        else:
            return "No vertices close enough to merge"

    def draw(self, context):
        layout = self.layout
        layout.prop(self, "merge_distance")


class MESH_OT_smart_uv_project_normal_groups(BaseSubmeshOperator, UVOperatorMixin):
    bl_idname = "mesh.smart_uv_project_normal_groups"
    bl_label = "Smart UV Project (Normal Groups)"
    bl_description = "Project UVs by grouping faces with similar normals across disconnected geometry"
    
    angle_threshold: FloatProperty(
        name="Angle Threshold",
        description="Maximum angle difference for faces to be grouped together",
        default=0.087266,
        min=0.0,
        max=math.pi/2,
        precision=3,
        subtype='ANGLE'
    )
    
    gap_distance: FloatProperty(
        name="Gap Distance",
        description="Maximum distance to bridge gaps between faces",
        default=0.001,
        min=0.0,
        max=0.1,
        precision=6,
        subtype='DISTANCE'
    )
    
    island_margin: FloatProperty(
        name="Island Margin",
        description="Margin between UV islands",
        default=0.003,
        min=0.0,
        max=0.5,
        precision=3
    )
    
    def build_face_spatial_cache(self, bm, selected_faces):
        """Build spatial cache for fast proximity queries"""
        face_centers = {}
        face_bounds = {}
        
        for face_idx in selected_faces:
            if face_idx >= len(bm.faces):
                continue
            face = bm.faces[face_idx]
            if face.hide:
                continue
                
            # Calculate center and bounds
            min_co = mathutils.Vector((float('inf'), float('inf'), float('inf')))
            max_co = mathutils.Vector((float('-inf'), float('-inf'), float('-inf')))
            center = mathutils.Vector((0, 0, 0))
            
            for vert in face.verts:
                co = vert.co
                center += co
                min_co.x = min(min_co.x, co.x)
                min_co.y = min(min_co.y, co.y)
                min_co.z = min(min_co.z, co.z)
                max_co.x = max(max_co.x, co.x)
                max_co.y = max(max_co.y, co.y)
                max_co.z = max(max_co.z, co.z)
            
            center /= len(face.verts)
            face_centers[face_idx] = center
            face_bounds[face_idx] = (min_co, max_co)
        
        return face_centers, face_bounds
    
    def build_combined_adjacency(self, bm, selected_faces, face_centers, face_bounds):
        """Build adjacency including both edge connections and spatial proximity"""
        angle_threshold_cos = math.cos(self.angle_threshold)
        gap_dist_sq = self.gap_distance * self.gap_distance
        
        # Build edge-based adjacency
        edge_adjacency = defaultdict(set)
        selected_set = set(selected_faces)
        
        for edge in bm.edges:
            if len(edge.link_faces) == 2:
                f1, f2 = edge.link_faces
                if f1.index in selected_set and f2.index in selected_set:
                    edge_adjacency[f1.index].add(f2.index)
                    edge_adjacency[f2.index].add(f1.index)
        
        # Build spatial grid for efficient proximity queries
        grid_size = max(self.gap_distance * 2, 0.01)
        spatial_grid = defaultdict(list)
        
        for face_idx in face_centers:
            center = face_centers[face_idx]
            grid_key = (
                int(center.x / grid_size),
                int(center.y / grid_size),
                int(center.z / grid_size)
            )
            
            # Add to neighboring grid cells as well
            for dx in [-1, 0, 1]:
                for dy in [-1, 0, 1]:
                    for dz in [-1, 0, 1]:
                        neighbor_key = (
                            grid_key[0] + dx,
                            grid_key[1] + dy,
                            grid_key[2] + dz
                        )
                        spatial_grid[neighbor_key].append(face_idx)
        
        # Build proximity adjacency if gap distance is significant
        proximity_adjacency = defaultdict(set)
        
        if self.gap_distance > 0.0001:
            # Build face-to-vertex mapping with spatial hashing
            face_vertex_grid = defaultdict(set)
            
            for face_idx in selected_faces:
                face = bm.faces[face_idx]
                for vert in face.verts:
                    v_key = (
                        int(vert.co.x / grid_size),
                        int(vert.co.y / grid_size),
                        int(vert.co.z / grid_size)
                    )
                    face_vertex_grid[v_key].add(face_idx)
            
            # Find proximity connections
            processed_pairs = set()
            
            for face_idx in selected_faces:
                if face_idx not in face_centers:
                    continue
                    
                face = bm.faces[face_idx]
                face_normal = face.normal.normalized()
                
                # Find candidate faces through vertex proximity
                candidates = set()
                
                for vert in face.verts:
                    v_key = (
                        int(vert.co.x / grid_size),
                        int(vert.co.y / grid_size),
                        int(vert.co.z / grid_size)
                    )
                    
                    # Check neighboring grid cells
                    for dx in [-1, 0, 1]:
                        for dy in [-1, 0, 1]:
                            for dz in [-1, 0, 1]:
                                neighbor_key = (v_key[0] + dx, v_key[1] + dy, v_key[2] + dz)
                                candidates.update(face_vertex_grid.get(neighbor_key, set()))
                
                candidates.discard(face_idx)
                
                # Check each candidate
                for other_idx in candidates:
                    pair = (min(face_idx, other_idx), max(face_idx, other_idx))
                    if pair in processed_pairs:
                        continue
                    processed_pairs.add(pair)
                    
                    other_face = bm.faces[other_idx]
                    
                    # Check normal similarity first
                    if face_normal.dot(other_face.normal.normalized()) < angle_threshold_cos:
                        continue
                    
                    # Quick bounds check
                    bounds1 = face_bounds[face_idx]
                    bounds2 = face_bounds[other_idx]
                    
                    min_dist_sq = 0.0
                    for i in range(3):
                        if bounds1[1][i] < bounds2[0][i]:
                            d = bounds2[0][i] - bounds1[1][i]
                            min_dist_sq += d * d
                        elif bounds2[1][i] < bounds1[0][i]:
                            d = bounds1[0][i] - bounds2[1][i]
                            min_dist_sq += d * d
                    
                    if min_dist_sq > gap_dist_sq:
                        continue
                    
                    # Check if any vertices are close
                    found_close = False
                    for v1 in face.verts:
                        for v2 in other_face.verts:
                            if (v1.co - v2.co).length_squared <= gap_dist_sq:
                                found_close = True
                                break
                        if found_close:
                            break
                    
                    if found_close:
                        proximity_adjacency[face_idx].add(other_idx)
                        proximity_adjacency[other_idx].add(face_idx)
        
        # Combine adjacencies - ensure ALL selected faces are in the result
        combined = defaultdict(set)
        
        # First, add all selected faces (even isolated ones)
        for face_idx in selected_faces:
            combined[face_idx] = set()
        
        # Then add adjacency information
        for face_idx in edge_adjacency:
            combined[face_idx].update(edge_adjacency[face_idx])
        
        for face_idx in proximity_adjacency:
            combined[face_idx].update(proximity_adjacency[face_idx])
        
        return combined
    
    def find_face_groups_flood_fill(self, selected_faces, adjacency, bm):
        """Efficient flood fill to find connected face groups respecting angle threshold"""
        visited = set()
        groups = []
        angle_threshold_cos = math.cos(self.angle_threshold)
        
        for start_face in selected_faces:
            if start_face in visited:
                continue
            
            # Flood fill from this face
            group = []
            queue = deque([start_face])
            
            while queue:
                face_idx = queue.popleft()
                if face_idx in visited:
                    continue
                
                visited.add(face_idx)
                group.append(face_idx)
                
                # Get current face normal
                current_face = bm.faces[face_idx]
                current_normal = current_face.normal.normalized()
                
                # Add unvisited neighbors if their normals are similar enough
                for neighbor in adjacency.get(face_idx, []):
                    if neighbor not in visited:
                        neighbor_face = bm.faces[neighbor]
                        neighbor_normal = neighbor_face.normal.normalized()
                        
                        # Check angle threshold
                        if current_normal.dot(neighbor_normal) >= angle_threshold_cos:
                            queue.append(neighbor)
            
            if group:
                groups.append(group)
        
        return groups
    
    def calculate_projection_matrix(self, face_group, bm):
        """Calculate optimal projection matrix for a group of faces"""
        if not face_group:
            return None, None
        
        # Calculate weighted average normal and center
        avg_normal = mathutils.Vector((0, 0, 0))
        total_area = 0.0
        center = mathutils.Vector((0, 0, 0))
        
        for face_idx in face_group:
            if face_idx < len(bm.faces):
                face = bm.faces[face_idx]
                area = face.calc_area()
                if area > 0:
                    avg_normal += face.normal * area
                    total_area += area
                    center += face.calc_center_median() * area
        
        if total_area <= 0:
            return None, None
        
        avg_normal /= total_area
        center /= total_area
        avg_normal.normalize()
        
        # Create orthonormal basis
        if abs(avg_normal.z) < 0.9:
            u_axis = mathutils.Vector((0, 0, 1)).cross(avg_normal)
        else:
            u_axis = mathutils.Vector((1, 0, 0)).cross(avg_normal)
        u_axis.normalize()
        
        v_axis = avg_normal.cross(u_axis)
        v_axis.normalize()
        
        # Create projection matrix
        projection_matrix = mathutils.Matrix((
            (u_axis.x, u_axis.y, u_axis.z),
            (v_axis.x, v_axis.y, v_axis.z)
        ))
        
        return projection_matrix, center
    
    def project_faces_to_uv(self, face_group, projection_matrix, center, bm, uv_layer):
        """Project faces in a group to UV coordinates"""
        if not face_group or projection_matrix is None:
            return None
        
        # Project all vertices
        projected_uvs = {}
        min_uv = mathutils.Vector((float('inf'), float('inf')))
        max_uv = mathutils.Vector((float('-inf'), float('-inf')))
        
        for face_idx in face_group:
            if face_idx >= len(bm.faces):
                continue
                
            face = bm.faces[face_idx]
            for loop in face.loops:
                relative_pos = loop.vert.co - center
                uv_2d = projection_matrix @ relative_pos
                uv = mathutils.Vector((uv_2d.x, uv_2d.y))
                
                projected_uvs[loop] = uv
                min_uv.x = min(min_uv.x, uv.x)
                min_uv.y = min(min_uv.y, uv.y)
                max_uv.x = max(max_uv.x, uv.x)
                max_uv.y = max(max_uv.y, uv.y)
        
        if not projected_uvs:
            return None
        
        size = max_uv - min_uv
        if size.x <= 0 or size.y <= 0:
            return None
        
        return {
            'min_uv': min_uv,
            'max_uv': max_uv,
            'size': size,
            'projected_uvs': projected_uvs,
            'face_count': len(face_group),
            'face_indices': face_group
        }
    
    def pack_uv_islands_growing(self, islands, bm, uv_layer):
        """Pack UV islands using shelf packing with uniform texel density
        
        Algorithm:
        1. Calculates a uniform scale factor based on 3D surface area to normalize texel density
        2. Sorts islands by height (tallest first) for efficient shelf packing
        3. Places islands on horizontal shelves with smart height matching (50%-200% tolerance)
        4. Maintains consistent margins between islands
        5. Uses two-pass approach to achieve near-square aspect ratio
        6. Scales result to fit within UV space (0-1 range)
        
        This produces approximately square UV layouts even with significant padding.
        """
        import math
        
        if not islands:
            return
        
        # Filter valid islands and calculate 3D surface area
        valid_islands = []
        total_3d_area = 0.0
        
        for island in islands:
            if island and island['size'].x > 0 and island['size'].y > 0:
                # Calculate 3D surface area for this island
                surface_area_3d = sum(
                    bm.faces[face_idx].calc_area() 
                    for face_idx in island.get('face_indices', [])
                    if face_idx < len(bm.faces)
                )
                
                island['surface_area_3d'] = surface_area_3d
                total_3d_area += surface_area_3d
                valid_islands.append(island)
        
        if not valid_islands:
            return
        
        # Calculate uniform scale to normalize texel density
        target_coverage = 0.8  # Use 80% of UV space
        uniform_scale = math.sqrt(target_coverage / total_3d_area) if total_3d_area > 0 else 1.0
        
        # Apply uniform scale to all islands and inflate by margin
        for island in valid_islands:
            island['scaled_size'] = island['size'] * uniform_scale
            
            # Check if rotating by 90 degrees would be beneficial (make it wider than tall)
            if island['scaled_size'].y > island['scaled_size'].x:
                # Rotate the island by swapping dimensions
                island['rotated'] = True
                island['scaled_size'] = mathutils.Vector((
                    island['scaled_size'].y,
                    island['scaled_size'].x
                ))
            else:
                island['rotated'] = False
            
            # Inflate the island size by margin on all sides for packing
            island['inflated_size'] = mathutils.Vector((
                island['scaled_size'].x + 2 * self.island_margin,
                island['scaled_size'].y + 2 * self.island_margin
            ))
        
        # Sort by height (tallest first) for shelf packing
        valid_islands.sort(key=lambda x: x['inflated_size'].y, reverse=True)
        
        # Calculate total area using inflated sizes
        total_area_inflated = sum(island['inflated_size'].x * island['inflated_size'].y for island in valid_islands)
        
        # Initial target width based on inflated area
        target_width = math.sqrt(total_area_inflated)
        
        # Two-pass packing for better aspect ratio
        for pass_num in range(2):
            # Shelf packing
            shelves = []
            current_y = 0
            
            for island in valid_islands:
                width = island['inflated_size'].x
                height = island['inflated_size'].y
                
                # Find a suitable shelf
                placed = False
                for shelf in shelves:
                    # Check horizontal space
                    if shelf['current_x'] + width <= target_width:
                        # Place on this shelf (no height restriction)
                        island['pack_position'] = mathutils.Vector((
                            shelf['current_x'],
                            shelf['y_position']
                        ))
                        shelf['current_x'] += width
                        placed = True
                        break
                
                if not placed:
                    # Create new shelf
                    island['pack_position'] = mathutils.Vector((0, current_y))
                    shelves.append({
                        'y_position': current_y,
                        'height': height,
                        'current_x': width
                    })
                    current_y += height
            
            # Calculate actual packed dimensions
            pack_width = max(shelf['current_x'] for shelf in shelves) if shelves else target_width
            pack_height = current_y
            
            # After first pass, calculate better target width based on actual dimensions
            if pass_num == 0:
                if pack_width > pack_height:
                    # Too wide, need narrower target
                    target_width = math.sqrt(total_area_inflated * pack_height / pack_width)
                else:
                    # Too tall, need wider target
                    target_width = math.sqrt(total_area_inflated * pack_width / pack_height)
        
        # Improvement 3: Trim unused space from each shelf
        for shelf in shelves:
            shelf['actual_width'] = shelf['current_x']  # Store actual used width
        
        # Improvement 4: Compact shelves vertically
        # Sort shelves by height for better vertical packing
        shelves.sort(key=lambda s: s['height'], reverse=True)
        
        # Re-stack shelves with actual widths
        compacted_y = 0
        for shelf in shelves:
            # Update all islands on this shelf with new Y position
            y_offset = compacted_y - shelf['y_position']
            for island in valid_islands:
                if 'pack_position' in island and abs(island['pack_position'].y - shelf['y_position']) < 0.0001:
                    island['pack_position'].y += y_offset
            
            shelf['y_position'] = compacted_y
            compacted_y += shelf['height']
        
        # Update pack height after compaction
        pack_height = compacted_y
        
        # Recalculate pack width after compaction using actual shelf widths
        pack_width = max(shelf['actual_width'] for shelf in shelves) if shelves else target_width
        
        # Calculate final scale to fit UV space
        scale_factor = min(1.0 / pack_width, 1.0 / pack_height)
        
        # Apply UV coordinates
        for island in valid_islands:
            if 'pack_position' not in island:
                continue
            
            # Scale the inflated position and then add margin to get the actual position
            scaled_position = island['pack_position'] * scale_factor
            # The actual island position is the inflated position plus the margin
            actual_position = scaled_position + mathutils.Vector((self.island_margin, self.island_margin))
            
            size_scale = uniform_scale * scale_factor
            min_uv = island['min_uv']
            
            # Apply to all loops
            for loop, original_uv in island['projected_uvs'].items():
                # Apply rotation if needed
                if island.get('rotated', False):
                    # Rotate 90 degrees counterclockwise: (x, y) -> (-y, x)
                    # But we want to keep it in positive space, so we do (x, y) -> (y, -x) then flip
                    rotated_uv = mathutils.Vector((
                        original_uv.y - min_uv.y,
                        -(original_uv.x - min_uv.x) + (island['max_uv'].x - island['min_uv'].x)
                    ))
                    new_uv = rotated_uv * size_scale + actual_position
                else:
                    new_uv = (original_uv - min_uv) * size_scale + actual_position
                loop[uv_layer].uv = new_uv
        
        # Report results
        # Calculate actual area (non-inflated) for efficiency calculation
        total_area = sum(island['scaled_size'].x * island['scaled_size'].y for island in valid_islands)
        efficiency = total_area / (pack_width * pack_height) if pack_height > 0 else 0
        aspect_ratio = pack_width / pack_height if pack_height > 0 else 1.0
        rotated_count = sum(1 for island in valid_islands if island.get('rotated', False))
        
        print(f"\n  Packed {len(valid_islands)} UV islands ({rotated_count} rotated)")
        print(f"  Shelves: {len(shelves)}, Aspect ratio: {aspect_ratio:.2f}, Efficiency: {efficiency:.0%}")
    
    def process_object(self, context, obj):
        import time
        
        print(f"\nProcessing object: {obj.name}")
        start_time = time.time()
        
        bm = bmesh.from_edit_mesh(obj.data)
        bm.faces.ensure_lookup_table()
        
        # Get or create UV layer
        if not bm.loops.layers.uv:
            bm.loops.layers.uv.new("UVMap")
        uv_layer = bm.loops.layers.uv.active
        
        if not uv_layer:
            print("  ERROR: No UV layer available")
            return False, {}
        
        # Get selected faces
        selected_faces = [face.index for face in bm.faces if face.select and not face.hide]
        
        print(f"  Selected faces: {len(selected_faces)}")
        
        if not selected_faces:
            return False, {}
        
        # Build spatial cache
        face_centers, face_bounds = self.build_face_spatial_cache(bm, selected_faces)
        
        # Build combined adjacency
        adjacency = self.build_combined_adjacency(bm, selected_faces, face_centers, face_bounds)
        
        # Find face groups using flood fill
        face_groups = self.find_face_groups_flood_fill(selected_faces, adjacency, bm)
        print(f"  Found {len(face_groups)} face groups")
        
        if not face_groups:
            return False, {}
        
        # Process each group
        islands = []
        processed_faces = 0
        
        for group in face_groups:
            projection_matrix, center = self.calculate_projection_matrix(group, bm)
            if projection_matrix is not None:
                island_data = self.project_faces_to_uv(group, projection_matrix, center, bm, uv_layer)
                if island_data:
                    islands.append(island_data)
                    processed_faces += island_data['face_count']
        
        print(f"  Created {len(islands)} UV islands")
        
        # Pack islands
        if islands:
            self.pack_uv_islands_growing(islands, bm, uv_layer)
        
        bmesh.update_edit_mesh(obj.data)
        
        print(f"  Total time: {time.time()-start_time:.2f}s")
        
        return True, {
            'groups': len(face_groups),
            'islands': len(islands),
            'faces': processed_faces
        }
    
    def format_report(self, stats):
        if stats['object_count'] == 0:
            return "No objects processed"
        
        return f"Created {stats['islands']} UV islands from {stats['groups']} face groups ({stats['faces']} faces) across {stats['object_count']} object(s)"
    
    def draw(self, context):
        layout = self.layout
        layout.prop(self, "angle_threshold")
        layout.prop(self, "gap_distance")
        layout.prop(self, "island_margin")


class MESH_OT_bake_origin_and_orientation_combined(BaseSubmeshOperator):
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
        description="Cache calculations for identical submeshes to avoid recomputing basis and scale",
        default=True
    )

    def calculate_island_center(self, vertices):
        """Calculate center for an island"""
        if not vertices:
            return None

        center = mathutils.Vector((0.0, 0.0, 0.0))
        for v in vertices:
            center += v.co
        center /= len(vertices)

        return center
    
    def calculate_island_scale(self, vertices, center, basis_inv):
        """Calculate scale using L-infinity norm in rotated basis"""
        if not vertices:
            return 1.0
        
        max_coord = 0.0
        for v in vertices:
            offset = v.co - center
            local_pos = basis_inv @ offset
            
            max_coord = max(max_coord, abs(local_pos.x), abs(local_pos.y), abs(local_pos.z))
        
        scale = 1.0 / max_coord if max_coord > 0 else 1.0
        return scale

    def build_basis_from_faces(self, faces, epsilon):
        """Build orthonormal basis from face normals"""
        if not faces:
            return mathutils.Matrix.Identity(3)

        # Sort faces by area
        sorted_faces = sorted(faces, key=lambda f: f.calc_area(), reverse=True)
        x_axis = sorted_faces[0].normal.normalized()

        epsilon_cos = math.cos(epsilon)
        y_axis = None

        for face in sorted_faces[1:]:
            normal = face.normal.normalized()
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

    def create_submesh_signature(self, vertices, center):
        """Create signature for caching - based on relative positions only"""
        tolerance = 0.0001
        relative_positions = []

        for v in vertices:
            relative_pos = v.co - center
            rounded = tuple(round(relative_pos[i] / tolerance) * tolerance for i in range(3))
            relative_positions.append(rounded)

        relative_positions.sort()
        return (len(vertices), tuple(relative_positions))

    def process_object(self, context, obj):
        mesh = obj.data
        
        # Switch to object mode temporarily to ensure vertex colors exist
        bpy.ops.object.mode_set(mode='OBJECT')
        
        if not mesh.vertex_colors:
            mesh.vertex_colors.new(name="BakedVectors")
        color_layer = mesh.vertex_colors.active

        uv_layer0 = MeshUtils.get_or_create_uv_layer(mesh, "BakedOriginAngle0")
        uv_layer1 = MeshUtils.get_or_create_uv_layer(mesh, "BakedOriginAngle1")
        
        # Switch back to edit mode
        bpy.ops.object.mode_set(mode='EDIT')
        
        # Get BMesh for edit mode operations
        bm = bmesh.from_edit_mesh(mesh)
        bm.verts.ensure_lookup_table()
        bm.faces.ensure_lookup_table()
        
        # Get vertex color and UV layers in BMesh
        if not bm.loops.layers.color:
            bm.loops.layers.color.new("BakedVectors")
        bm_color_layer = bm.loops.layers.color.active
        
        uv_layers = bm.loops.layers.uv
        bm_uv_layer0 = uv_layers.get("BakedOriginAngle0")
        bm_uv_layer1 = uv_layers.get("BakedOriginAngle1")
        
        if not bm_uv_layer0:
            bm_uv_layer0 = uv_layers.new("BakedOriginAngle0")
        if not bm_uv_layer1:
            bm_uv_layer1 = uv_layers.new("BakedOriginAngle1")
        
        selected_verts = [v for v in bm.verts if v.select]
        if not selected_verts:
            return False, {}

        settings = context.scene.bake_vertex_settings
        correction = mathutils.Euler(
            (settings.correction_angle_x, settings.correction_angle_y, settings.correction_angle_z), 'XYZ'
        ).to_quaternion()

        # Get selected faces
        selected_faces = []
        for face in bm.faces:
            if all(v.select for v in face.verts):
                selected_faces.append(face)

        # Build islands using BMesh vertices
        if self.contiguous_mode:
            selected_indices = {v.index for v in selected_verts}
            adjacency = {v.index: set() for v in selected_verts}
            
            for edge in bm.edges:
                v0, v1 = edge.verts[0].index, edge.verts[1].index
                if v0 in selected_indices and v1 in selected_indices:
                    adjacency[v0].add(v1)
                    adjacency[v1].add(v0)
            
            island_indices = MeshUtils.find_islands(selected_indices, adjacency)
            islands = []
            for island_idx_set in island_indices:
                island_verts = [bm.verts[idx] for idx in island_idx_set]
                islands.append(island_verts)
        else:
            islands = [selected_verts]

        world_matrix = obj.matrix_world
        world_inv = world_matrix.inverted()
        
        submesh_cache = {} if self.use_cache else None

        for island_verts in islands:
            center = self.calculate_island_center(island_verts)
            if center is None:
                continue

            cache_hit = False
            if self.use_cache:
                signature = self.create_submesh_signature(island_verts, center)
                if signature in submesh_cache:
                    scale, basis, quat, basis_inv = submesh_cache[signature]
                    cache_hit = True

            if not cache_hit:
                # Get faces for this island
                island_faces = []
                island_vert_set = set(island_verts)
                for face in selected_faces:
                    if all(v in island_vert_set for v in face.verts):
                        island_faces.append(face)
                
                basis = self.build_basis_from_faces(island_faces, self.normal_epsilon)
                basis_inv = basis.inverted()
                
                scale = self.calculate_island_scale(island_verts, center, basis_inv)
                
                quat = basis.to_quaternion()
                quat.normalize()
                if quat.w < 0:
                    quat.negate()
                quat = correction @ quat
                
                if self.use_cache:
                    submesh_cache[signature] = (scale, basis, quat, basis_inv)

            center_world = world_matrix @ center

            # Apply to each vertex in the island
            for vert in island_verts:
                vert_world = world_matrix @ vert.co
                offset = world_inv.to_3x3() @ (vert_world - center_world)
                local_pos = basis_inv @ offset

                color = mathutils.Vector((
                    (local_pos.x * scale + 1.0) * 0.5,
                    (local_pos.y * scale + 1.0) * 0.5,
                    (local_pos.z * scale + 1.0) * 0.5,
                    scale
                ))

                # Apply to all loops of this vertex
                for face in vert.link_faces:
                    if face.select:
                        for loop in face.loops:
                            if loop.vert == vert:
                                loop[bm_color_layer] = color
                                loop[bm_uv_layer0].uv = (quat.x, quat.y)
                                loop[bm_uv_layer1].uv = (quat.z, quat.w)

        # Update the mesh
        bmesh.update_edit_mesh(mesh)

        return True, {
            'islands': len(islands),
            'vertices': len(selected_verts)
        }

    def format_report(self, stats):
        if stats['object_count'] == 0:
            return "No objects processed"
        
        return f"Baked {stats['islands']} island(s) with {stats['vertices']} vertices across {stats['object_count']} object(s)"

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
            col.operator("mesh.select_hidden_faces", icon='GHOST_ENABLED')
            col.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
            col.operator("mesh.merge_by_distance_per_submesh", icon='AUTOMERGE_ON')
            col.operator("mesh.pack_uv_islands_by_submesh_z", icon='UV')
            col.operator("mesh.smart_uv_project_normal_groups", icon='UV_DATA')
        else:
            layout.label(text="Enter Edit Mode to use tools", icon='INFO')


classes = [
    BakeVertexSettings,
    MESH_OT_select_all_linked,
    MESH_OT_select_linked_across_boundaries,
    MESH_OT_deduplicate_submeshes,
    MESH_OT_select_hidden_faces,
    MESH_OT_pack_uv_islands_by_submesh_z,
    MESH_OT_merge_by_distance_per_submesh,
    MESH_OT_smart_uv_project_normal_groups,
    MESH_OT_bake_origin_and_orientation_combined,
    MESH_PT_bake_vertex_panel
]


def menu_func(self, context):
    self.layout.separator()
    self.layout.operator("mesh.select_all_linked", icon='SELECT_EXTEND')
    self.layout.operator("mesh.select_linked_across_boundaries", icon='LINKED')
    self.layout.operator("mesh.select_hidden_faces", icon='GHOST_ENABLED')
    self.layout.operator("mesh.deduplicate_submeshes", icon='DUPLICATE')
    self.layout.operator("mesh.merge_by_distance_per_submesh", icon='AUTOMERGE_ON')
    self.layout.operator("mesh.pack_uv_islands_by_submesh_z", icon='UV')
    self.layout.operator("mesh.smart_uv_project_normal_groups", icon='UV_DATA')
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
