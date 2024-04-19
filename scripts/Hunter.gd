extends Node3D

@export var groups_prefix: String = ""

var models: Array
var active_model_indices: Array


func _ready():
	var scene_tree = get_tree()

	for i in ArmorData.Category.COUNT:
		active_model_indices.append(0)

		var category_name = ArmorData.CATEGORY_NAMES[i]
		models.push_back(scene_tree.get_nodes_in_group(groups_prefix + category_name))


func get_models_in_category(model_category: ArmorData.Category):
	return models[model_category]


func set_model(model_category: ArmorData.Category, model_index: int):
	var active_index: int = active_model_indices[model_category]
	models[model_category][active_index].hide()

	active_model_indices[model_category] = model_index
	models[model_category][model_index].show()
