extends Control

@export var table_body: Node
@export var scroll_container: ScrollContainer
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
var scroll_when_next_shown: bool = false


func _ready():
	visibility_changed.connect(_on_visibility_changed)


func _on_armor_row_visibility_changed(armor_row):
	scroll_to_armor_row(armor_row)


func _on_visibility_changed():
	if is_visible() and scroll_when_next_shown:
		var armor_row = get_selected_armor()
		if armor_row and not is_armor_row_visible(armor_row):
			armor_row.draw.connect(_on_armor_row_visibility_changed.bind(armor_row), CONNECT_ONE_SHOT)


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
	if not is_visible():
		scroll_when_next_shown = true


func get_selected_armor():
	for child in table_body.get_children():
		if child.is_selected():
			return child


func is_armor_row_visible(armor_row) -> bool:
	var row_y: float = armor_row.get_position().y
	return scroll_container.scroll_vertical <= row_y and row_y + armor_row.size.y <= scroll_container.scroll_vertical + scroll_container.size.y


func scroll_to_armor_row(armor_row):
	if not is_visible():
		return

	scroll_container.set_v_scroll(armor_row.get_position().y)
	scroll_when_next_shown = false


func scroll_to_selected():
	var armor_row = get_selected_armor()
	if armor_row:
		scroll_to_armor_row(armor_row)
