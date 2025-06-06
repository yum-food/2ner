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
            islands = self.get_vertex_islands(mesh, selected_indices)
            total_updated = 0
            
            for island_indices in islands:
                center, max_dist, scale = self.get_island_info(mesh, island_indices)
                if center is None:
                    continue
                
                center_world = source_matrix @ center
                
                for poly in mesh.polygons:
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
    
    def invoke(self, context, event):
        return context.window_manager.invoke_props_dialog(self)


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
                col.separator()
                col.operator("mesh.bake_vertex_vectors", icon='EXPORT')
                
                box = col.box()
                box.label(text="Info:", icon='INFO')
                box.label(text="Select All Linked: Expand selection to full submeshes")
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
    MESH_PT_bake_vertex_panel
]


def menu_func(self, context):
    self.layout.separator()
    self.layout.operator("mesh.select_all_linked_submeshes", icon='SELECT_EXTEND')
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
