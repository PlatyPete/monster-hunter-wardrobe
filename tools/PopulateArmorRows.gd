@tool
extends EditorScript

const ArmorRow = preload("res://scripts/ArmorRow.gd")
const ArmorTable = preload("res://scripts/ArmorTable.gd")
const UIController = preload("res://scripts/UIController.gd")

var armor_row_scene: PackedScene = load("res://ui_elements/armor_row.tscn")


func _run():
	add_all_armor_rows()


func add_all_armor_rows():
	if Engine.is_editor_hint():
		var scene_root = get_scene()
		if scene_root is UIController:
			for armor_category in ArmorData.CATEGORY_COUNT:
				for armor_row in scene_root.armor_tables[armor_category].table_body.get_children():
					armor_row.queue_free()

			for game_version in ArmorData.Game.BOTH:
				for gender in ArmorData.Gender.BOTH:
					for armor_category in ArmorData.CATEGORY_COUNT:
						var armor_index: int = 0
						for armor_data in ArmorData.ARMOR[game_version][armor_category]:
							# Only add an armor row if this armor piece is valid for the current gender
							if not armor_data.has("gender") or armor_data.gender == gender:
								var armor_row: ArmorRow = armor_row_scene.instantiate() as ArmorRow
								scene_root.armor_tables[armor_category].table_body.add_child(armor_row)
								set_armor_row_data(armor_row, game_version, armor_category, gender, armor_index, armor_data)
								armor_row.owner = scene_root
								print("Armor row created: ", game_version, ", ", armor_category, ", ", gender)

							armor_index += 1


func set_armor_row_data(armor_row: ArmorRow, game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Control:
	armor_row.armor_category = armor_category
	armor_row.gender = gender
	armor_row.armor_index = armor_index
	armor_row.game_version = game_version
	armor_row.hunter_class = armor_data.get("hunter_class", ArmorData.HunterClass.BOTH)

	match gender:
		ArmorData.Gender.FEMALE:
			armor_row.add_to_group("f_armor_rows")
		ArmorData.Gender.MALE:
			armor_row.add_to_group("m_armor_rows")

	return armor_row
