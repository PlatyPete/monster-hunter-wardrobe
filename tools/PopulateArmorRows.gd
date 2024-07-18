@tool
extends EditorScript

const ArmorCheckbox  = preload("res://scripts/ArmorCheckbox.gd");
const ArmorTable = preload("res://scripts/ArmorTable.gd")
const UIController = preload("res://scripts/UIController.gd")

var armor_checkbox_scene: PackedScene = load("res://ui_elements/armor_checkbox.tscn")


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
								var armor_checkbox: ArmorCheckbox = armor_checkbox_scene.instantiate() as ArmorCheckbox
								scene_root.armor_tables[armor_category].table_body.add_child(armor_checkbox)
								armor_checkbox.set_text(armor_data.name)
								armor_checkbox.owner = scene_root

								armor_checkbox.armor_category = armor_category
								armor_checkbox.armor_index = armor_index
								armor_checkbox.game_version = game_version
								armor_checkbox.gender = gender
								armor_checkbox.hunter_class = armor_data.get("hunter_class", ArmorData.HunterClass.BOTH)

								armor_checkbox.row_elements = generate_armor_elements(armor_checkbox, game_version, armor_category, gender, armor_index, armor_data)

								for element in armor_checkbox.row_elements:
									scene_root.armor_tables[armor_category].table_body.add_child(element)
									element.owner = scene_root
									if element is Label:
										element.set_custom_minimum_size(Vector2(20, 0))
										element.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)

								match game_version:
									ArmorData.Game.MH1:
										armor_checkbox.add_to_group("mh1_elements", true)
									ArmorData.Game.MHG:
										armor_checkbox.add_to_group("mhg_elements", true)

										var separator: VSeparator = VSeparator.new()
										armor_checkbox.row_elements.append(separator)
										scene_root.armor_tables[armor_category].table_body.add_child(separator)
										separator.owner = scene_root

										var skills_container: HBoxContainer = HBoxContainer.new()
										armor_checkbox.row_elements.append(skills_container)
										scene_root.armor_tables[armor_category].table_body.add_child(skills_container)
										skills_container.owner = scene_root

										var skill_index: int = 0
										for skill in armor_data.get("skills", []):
											var skill_name: Label = Label.new()
											skills_container.add_child(skill_name)
											skill_name.set_text(skill.k)
											skill_name.owner = scene_root

											var skill_quantity: Label = Label.new()
											skills_container.add_child(skill_quantity)
											skill_quantity.owner = scene_root

											skill_index += 1
											var sign: String = ""
											if skill.q > 0:
												sign = "+"

											if skill_index < armor_data.skills.size():
												skill_quantity.set_text("%s%d," % [sign, skill.q])
											else:
												skill_quantity.set_text("%s%d" % [sign, skill.q])

								match gender:
									ArmorData.Gender.FEMALE:
										armor_checkbox.add_to_group("f_armor_rows", true)
									ArmorData.Gender.MALE:
										armor_checkbox.add_to_group("m_armor_rows", true)

								print("Armor row created: ", game_version, ", ", armor_category, ", ", gender)

							armor_index += 1


func generate_armor_elements(armor_checkbox: ArmorCheckbox, game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Array[Node]:
	var row_elements: Array[Node]

	var separator: VSeparator = VSeparator.new()
	row_elements.append(separator)
	var defense_label: Label = Label.new()
	defense_label.set_text(str(armor_data.get("def", 0)))
	row_elements.append(defense_label)

	var res: Array = armor_data.get("res", [0, 0, 0, 0])

	separator = VSeparator.new()
	row_elements.append(separator)
	var fire_res_label: Label = Label.new()
	fire_res_label.set_text(str(res[0]))
	row_elements.append(fire_res_label)

	separator = VSeparator.new()
	row_elements.append(separator)
	var water_res_label: Label = Label.new()
	water_res_label.set_text(str(res[1]))
	row_elements.append(water_res_label)

	separator = VSeparator.new()
	row_elements.append(separator)
	var thunder_res_label: Label = Label.new()
	thunder_res_label.set_text(str(res[2]))
	row_elements.append(thunder_res_label)

	separator = VSeparator.new()
	row_elements.append(separator)
	var dragon_res_label: Label = Label.new()
	dragon_res_label.set_text(str(res[3]))
	row_elements.append(dragon_res_label)

	return row_elements
