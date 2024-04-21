extends Node3D

@export var gender: ArmorData.Gender

var models: Array
var active_model_indices: Array


func _ready():
	var scene_tree = get_tree()
	var groups_prefix = ArmorData.GENDER_PREFIXES[gender]

	for i in ArmorData.Category.COUNT:
		active_model_indices.append(0)

		var category_name = ArmorData.CATEGORY_NAMES[i]
		models.push_back(scene_tree.get_nodes_in_group(groups_prefix + category_name))


func equip_armor(game_version: int, armor_category: ArmorData.Category, armor_index: int):
	var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]

	if armor_piece.model_indices[gender] == 0:
		# Either the None option was picked, or a piercing, which has no model
		# TODO: choose the appropriate base model, based on which face is selected
		print("Armor piece should be removed")
	elif not armor_piece.has("gender") or armor_piece.gender == gender:
		set_model(armor_category, armor_piece.model_indices[gender])
	else:
		# This shouldn't happen, but I suppose it's possible?
		print("The selected armor is not valid for this gender")


func get_models_in_category(model_category: ArmorData.Category):
	return models[model_category]


func set_model(model_category: ArmorData.Category, model_index: int):
	var active_index: int = active_model_indices[model_category]
	models[model_category][active_index].hide()

	active_model_indices[model_category] = model_index
	models[model_category][model_index].show()
