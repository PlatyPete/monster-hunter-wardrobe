extends Control

@export var table_body: Node
@export var armor_row_scene: PackedScene

@export_group("Button Groups")
@export var f_button_group: ButtonGroup
@export var m_button_group: ButtonGroup

var armor_row_indices: Array = [
	[
		[],
		[]
	],
	[
		[],
		[]
	]
]


func add_armor_row(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Control:
	var new_armor_row = armor_row_scene.instantiate()

	table_body.add_child(new_armor_row)

	new_armor_row.set_all_data(game_version, armor_category, gender, armor_index, armor_data);

	match gender:
		ArmorData.Gender.FEMALE:
			new_armor_row.set_button_group(f_button_group)
			new_armor_row.add_to_group("f_armor_rows")
		ArmorData.Gender.MALE:
			new_armor_row.set_button_group(m_button_group)
			new_armor_row.add_to_group("m_armor_rows")

	armor_row_indices[game_version][gender].push_back(table_body.get_child_count() - 1)
	return new_armor_row


func equip_armor(game_version: ArmorData.Game, gender: ArmorData.Gender, armor_index: int):
	var armor_row_index: int = armor_row_indices[game_version][gender][armor_index]
	var armor_row = table_body.get_child(armor_row_index)
	armor_row.equip_armor()
	# TODO: scroll down so the active row is visible
