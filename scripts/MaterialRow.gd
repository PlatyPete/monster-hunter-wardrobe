extends HBoxContainer

var material_name: String


func get_material_name() -> String:
	return material_name


func set_material_name(new_material_name: String):
	material_name = new_material_name
	$MaterialName.set_text(new_material_name)


func set_materials(materials):
	$HairCount.set_text(str(materials.get(str(ArmorData.Category.HAIR), "")))
	$BodyCount.set_text(str(materials.get(str(ArmorData.Category.BODY), "")))
	$ArmsCount.set_text(str(materials.get(str(ArmorData.Category.ARMS), "")))
	$WaistCount.set_text(str(materials.get(str(ArmorData.Category.WAIST), "")))
	$LegsCount.set_text(str(materials.get(str(ArmorData.Category.LEGS), "")))
	$TotalCount.set_text(str(materials.total))
