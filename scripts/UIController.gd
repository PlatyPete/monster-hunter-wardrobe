extends Control

@export_group("Armor Containers")
@export var hair_container: Control
@export var body_container: Control
@export var arms_container: Control
@export var waist_container: Control
@export var legs_container: Control

var armor_row_scene: PackedScene

func _ready():
	armor_row_scene = $ResourcePreloader.get_resource("armor_row")


func add_armor_row(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Control:
	var new_armor_row = armor_row_scene.instantiate()
	var button_group: ButtonGroup
	var gender_prefix: String = ArmorData.GENDER_PREFIXES[gender]

	match armor_category:
		ArmorData.Category.HAIR:
			hair_container.add_child(new_armor_row)
			button_group = $ResourcePreloader.get_resource("%shair_buttons" % gender_prefix)
		ArmorData.Category.BODY:
			body_container.add_child(new_armor_row)
			button_group = $ResourcePreloader.get_resource("%sbody_buttons" % gender_prefix)
		ArmorData.Category.ARMS:
			arms_container.add_child(new_armor_row)
			button_group = $ResourcePreloader.get_resource("%sarms_buttons" % gender_prefix)
		ArmorData.Category.WAIST:
			waist_container.add_child(new_armor_row)
			button_group = $ResourcePreloader.get_resource("%swaist_buttons" % gender_prefix)
		ArmorData.Category.LEGS:
			legs_container.add_child(new_armor_row)
			button_group = $ResourcePreloader.get_resource("%slegs_buttons" % gender_prefix)
		_:
			return null

	new_armor_row.set_all_data(game_version, armor_category, armor_index, armor_data);
	new_armor_row.set_button_group(button_group)
	return new_armor_row
