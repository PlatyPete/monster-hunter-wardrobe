extends Control

@export var tab_icon: Texture
@export var name_label: Label
@export var table_body: Node
@export var scroll_container: ScrollContainer

const ArmorCheckbox  = preload("res://scripts/ArmorCheckbox.gd");
const GRID_COLUMNS: Array[int] = [11, 13]

var armor_checkboxes: Array[ArmorCheckbox]
var scroll_when_next_shown: bool = false


func _ready():
	for child in table_body.get_children():
		if child is ArmorCheckbox:
			armor_checkboxes.append(child)

	# visibility_changed.connect(_on_visibility_changed)


func _on_armor_row_visibility_changed(armor_row):
	scroll_to_armor_row(armor_row)


# func _on_visibility_changed():
# 	if is_visible():
# 		update_name_label()

# 		if scroll_when_next_shown:
# 			var armor_row = get_selected_armor()
# 			if armor_row and not is_armor_row_visible(armor_row):
# 				armor_row.draw.connect(_on_armor_row_visibility_changed.bind(armor_row), CONNECT_ONE_SHOT)


func equip_armor(game_version: ArmorData.Game, gender: ArmorData.Gender, armor_index: int):
	for checkbox in armor_checkboxes:
		if checkbox.game_version == game_version and checkbox.gender == gender and checkbox.armor_index == armor_index:
			checkbox.equip_armor()
			if not is_visible():
				scroll_when_next_shown = true
			return

	print("Armor not found: ", game_version, ", ", gender, ", ", armor_index)


func get_selected_armor():
	for checkbox in armor_checkboxes:
		if checkbox.is_pressed():
			return checkbox


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


func update_columns():
	table_body.set_columns(GRID_COLUMNS[ArmorData.game_version])


func update_layout():
	call_deferred("update_name_label")

	if scroll_when_next_shown:
		var armor_row = get_selected_armor()
		if armor_row and not is_armor_row_visible(armor_row):
			armor_row.draw.connect(_on_armor_row_visibility_changed.bind(armor_row), CONNECT_ONE_SHOT)


func update_name_label():
	var label_width: int = 0
	for checkbox in armor_checkboxes:
		if checkbox.is_visible():
			label_width = checkbox.size.x
			break

	print("Label width: ", label_width)
	name_label.set_custom_minimum_size(Vector2(label_width, 0))
