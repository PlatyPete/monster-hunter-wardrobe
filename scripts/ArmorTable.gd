extends Control

@export var table_body: Node
@export var armor_row_scene: PackedScene

@export_group("Button Groups")
@export var f_button_group: ButtonGroup
@export var m_button_group: ButtonGroup


func add_armor_row(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Control:
	var new_armor_row = armor_row_scene.instantiate()

	table_body.add_child(new_armor_row)

	new_armor_row.set_all_data(game_version, armor_category, armor_index, armor_data);

	match gender:
		ArmorData.Gender.FEMALE:
			new_armor_row.set_button_group(f_button_group)
			new_armor_row.add_to_group("f_armor_rows")
		ArmorData.Gender.MALE:
			new_armor_row.set_button_group(m_button_group)
			new_armor_row.add_to_group("m_armor_rows")

	return new_armor_row
