extends Control

@export var tab_icon: Texture
@export var table_body: Node
@export var scroll_container: ScrollContainer

@export_group("Button Groups")
@export var f_button_group: ButtonGroup
@export var m_button_group: ButtonGroup

var scroll_when_next_shown: bool = false


func _ready():
	for armor_row in table_body.get_children():
		match armor_row.gender:
			ArmorData.Gender.FEMALE:
				armor_row.set_button_group(f_button_group)
			ArmorData.Gender.MALE:
				armor_row.set_button_group(m_button_group)

	visibility_changed.connect(_on_visibility_changed)


func _on_armor_row_visibility_changed(armor_row):
	scroll_to_armor_row(armor_row)


func _on_visibility_changed():
	if is_visible() and scroll_when_next_shown:
		var armor_row = get_selected_armor()
		if armor_row and not is_armor_row_visible(armor_row):
			armor_row.draw.connect(_on_armor_row_visibility_changed.bind(armor_row), CONNECT_ONE_SHOT)


func equip_armor(game_version: ArmorData.Game, gender: ArmorData.Gender, armor_index: int):
	for child in table_body.get_children():
		if child.game_version == game_version and child.gender == gender and child.armor_index == armor_index:
			child.equip_armor()
			if not is_visible():
				scroll_when_next_shown = true
			return

	print("Armor not found: ", game_version, ", ", gender, ", ", armor_index)


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
