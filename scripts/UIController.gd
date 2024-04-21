extends Control

@export_group("Armor Tables")
@export var hair_table: Control
@export var body_table: Control
@export var arms_table: Control
@export var waist_table: Control
@export var legs_table: Control


func add_armor_row(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Control:
	match armor_category:
		ArmorData.Category.HAIR:
			return hair_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.BODY:
			return body_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.ARMS:
			return arms_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.WAIST:
			return waist_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.LEGS:
			return legs_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)

	return null
