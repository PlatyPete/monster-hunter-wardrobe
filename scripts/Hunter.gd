extends Node3D

@export var gender: ArmorData.Gender
@export var skin_textures: Array[Texture2D]

var active_model_indices: Array[int] = [0,0,0,0,0,0]
var armor_indices: Array[int] = [
	0,0,0,0,0,
	0,0,0,0,0
]
var hair_index: int = 0
var hair_color: Color
var models: Array
var skin_index: int = 0


func _ready():
	var scene_tree = get_tree()
	var groups_prefix = ArmorData.GENDER_PREFIXES[gender]

	for i in ArmorData.Category.COUNT:
		var category_name = ArmorData.CATEGORY_NAMES[i]
		models.push_back(scene_tree.get_nodes_in_group(groups_prefix + category_name))

	ArmorData.game_changed.connect(_on_game_changed)


func _on_game_changed(game_version: ArmorData.Game):
	for model_category in ArmorData.Category.FACE:
		var armor_index: int = armor_indices[ArmorData.Category.FACE * ArmorData.game_version + model_category]
		equip_armor(ArmorData.game_version, model_category, armor_index)


func equip_armor(game_version: int, armor_category: ArmorData.Category, armor_index: int):
	var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]

	if armor_piece.model_indices[gender] == 0:
		# Either the None option was picked, or a piercing, which has no model
		armor_indices[ArmorData.Category.FACE * ArmorData.game_version + armor_category] = 0
		set_base_model(armor_category)
	elif not armor_piece.has("gender") or armor_piece.gender == gender:
		armor_indices[ArmorData.Category.FACE * ArmorData.game_version + armor_category] = armor_index
		set_model(armor_category, armor_piece.model_indices[gender])
	else:
		# This shouldn't happen, but I suppose it's possible?
		print("The selected armor is not valid for this gender")


func get_models_in_category(model_category: ArmorData.Category):
	return models[model_category]


func is_armor_equipped(model_category: ArmorData.Category) -> bool:
	return armor_indices[ArmorData.FACE * ArmorData.game_version + model_category] != 0


func set_base_model(model_category: ArmorData.Category):
	match model_category:
		ArmorData.Category.HAIR:
			set_hair(hair_index)
		ArmorData.Category.BODY, ArmorData.Category.ARMS, ArmorData.Category.LEGS:
			var model_index: int = ArmorData.get_base_model_index(model_category, gender, skin_index)
			set_model(model_category, model_index)


func set_hair(new_hair_index: int):
	hair_index = new_hair_index
	set_model(ArmorData.Category.HAIR, new_hair_index)


func set_hair_color(new_hair_color: Color):
	hair_color = new_hair_color

	var active_index: int = active_model_indices[ArmorData.Category.HAIR]
	var model_mesh: Mesh = models[ArmorData.Category.HAIR][active_index].get_mesh()
	var hair_material: StandardMaterial3D = model_mesh.surface_get_material(0)
	hair_material.set_albedo(hair_color)


func set_model(model_category: ArmorData.Category, model_index: int):
	var active_index: int = active_model_indices[model_category]
	models[model_category][active_index].hide()

	active_model_indices[model_category] = model_index
	models[model_category][model_index].show()

	match model_category:
		ArmorData.Category.HAIR:
			set_hair_color(hair_color)
		ArmorData.Category.BODY, ArmorData.Category.ARMS, ArmorData.Category.LEGS:
			set_model_skin(model_category)
		ArmorData.Category.FACE:
			skin_index = ArmorData.FACE_SKIN_MAP[gender][model_index]

			if is_armor_equipped(ArmorData.Category.BODY):
				set_model_skin(ArmorData.Category.BODY)
			else:
				set_model(ArmorData.Category.BODY, ArmorData.get_base_model_index(ArmorData.Category.BODY, gender, skin_index))

			if is_armor_equipped(ArmorData.Category.ARMS):
				set_model_skin(ArmorData.Category.ARMS)
			else:
				set_model(ArmorData.Category.ARMS, ArmorData.get_base_model_index(ArmorData.Category.ARMS, gender, skin_index))

			if is_armor_equipped(ArmorData.Category.LEGS):
				set_model_skin(ArmorData.Category.LEGS)
			else:
				set_model(ArmorData.Category.LEGS, ArmorData.get_base_model_index(ArmorData.Category.LEGS, gender, skin_index))


func set_model_skin(model_category: ArmorData.Category):
	var model_index: int = active_model_indices[model_category]
	if ArmorData.does_model_have_skin(model_category, gender, model_index):
		var model_mesh: Mesh = models[model_category][model_index].get_mesh()
		var skin_material: StandardMaterial3D = model_mesh.surface_get_material(0)
		skin_material.albedo_texture = skin_textures[skin_index]
