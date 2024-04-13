@tool # Needed so it runs in editor.
extends EditorScenePostImport

# Called right after the scene is imported and gets the root node.
func _post_import(scene):
	var skeleton = get_node("Armature/Skeleton3D")

	for mesh_instance in skeleton.get_children():
		mesh_instance = set_mesh_materials(mesh_instance)

	return scene # Remember to return the imported scene

func set_mesh_materials(node: MeshInstance3D) -> MeshInstance3D:
	var node_mesh: Mesh = node.get_mesh()

	for surface_index in node_mesh.get_surface_count():
		var surface_material: StandardMaterial3D = node_mesh.surface_get_material(surface_index)

		surface_material.set_transparency(StandardMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS)
		surface_material.set_shading_mode(StandardMaterial3D.SHADING_MODE_PER_VERTEX)
		surface_material.set_specular_mode(StandardMaterial3D.SPECULAR_DISABLED)

		node_mesh.surface_set_material(surface_index, surface_material)

	node.set_mesh(node_mesh)
	return node
