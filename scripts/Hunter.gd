extends Node3D

@export var gender: ArmorData.Gender

var active_model_indices: Array[int] = [0,0,0,0,0,0]
var armor_indices: Array[int] = [0,0,0,0,0]
var models: Array
var skin_index: int = 0


func _ready():
	var scene_tree = get_tree()
	var groups_prefix = ArmorData.GENDER_PREFIXES[gender]

	for i in ArmorData.Category.COUNT:
		var category_name = ArmorData.CATEGORY_NAMES[i]
		models.push_back(scene_tree.get_nodes_in_group(groups_prefix + category_name))


func equip_armor(game_version: int, armor_category: ArmorData.Category, armor_index: int):
	var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]

	if armor_piece.model_indices[gender] == 0:
		# Either the None option was picked, or a piercing, which has no model
		armor_indices[armor_category] = 0
		# TODO: choose the appropriate base model, based on which face is selected
		print("Armor piece should be removed")
	elif not armor_piece.has("gender") or armor_piece.gender == gender:
		armor_indices[armor_category] = armor_index
		set_model(armor_category, armor_piece.model_indices[gender])
	else:
		# This shouldn't happen, but I suppose it's possible?
		print("The selected armor is not valid for this gender")


func get_models_in_category(model_category: ArmorData.Category):
	return models[model_category]


func is_armor_equipped(model_category: ArmorData.Category) -> bool:
	return armor_indices[model_category] != 0


func set_model(model_category: ArmorData.Category, model_index: int):
	var active_index: int = active_model_indices[model_category]
	models[model_category][active_index].hide()

	active_model_indices[model_category] = model_index
	models[model_category][model_index].show()

	match model_category:
		ArmorData.Category.FACE:
			skin_index = ArmorData.FACE_SKIN_MAP[gender][model_index]
			set_model_skin(ArmorData.Category.BODY)
			set_model_skin(ArmorData.Category.ARMS)
			set_model_skin(ArmorData.Category.LEGS)


func set_model_skin(model_category: ArmorData.Category):
	if is_armor_equipped(model_category):
		# TODO: if the armor piece has skin
			# TODO: set the appropriate skin texture to the 0th material
		pass
	else:
		var model_index: int = ArmorData.get_base_model_index(model_category, gender, skin_index)
		set_model(model_category, model_index)
