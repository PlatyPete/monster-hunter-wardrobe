extends Control

enum Option { AUDIO }

signal face_changed(gender: ArmorData.Gender, face_index: int)
signal gender_changed(gender: ArmorData.Gender)
signal hair_changed(gender: ArmorData.Gender, hair_index: int)
signal hair_color_changed(gender: ArmorData.Gender, hair_color: Color)
signal room_changed(room_index: int)

@export_group("Toolbar")
@export var game_options: OptionButton
@export var room_options: OptionButton
@export var options_dropdown: MenuButton
@export var quit_button: Button

@export_group("Armor Menu")
@export var hair_table: Control
@export var body_table: Control
@export var arms_table: Control
@export var waist_table: Control
@export var legs_table: Control
@export var tab_container: TabContainer
@export var armor_icons: Array[Texture2D]

@export_group("Hunter Tab")
@export var female_check: CheckBox
@export var male_check: CheckBox
@export var f_face_options: OptionButton
@export var f_hair_options: OptionButton
@export var f_hair_color: ColorPickerButton
@export var m_face_options: OptionButton
@export var m_hair_options: OptionButton
@export var m_hair_color: ColorPickerButton
@export var sword_check: CheckBox
@export var gun_check: CheckBox

@export_group("Stats Tab")
@export var stats_container: Control
@export var skill_rows: Control
@export var skill_row_scene: PackedScene
@export var active_skill_container: VBoxContainer

@export_group("Materials Tab")
@export var material_rows: VBoxContainer
@export var material_row_scene: PackedScene
@export var forge_row: Control
@export var buy_row: Control

const HAIR_COLORS: Array[Color] = [
	Color("#e59a67"),
	Color("#bf7a59"),
	Color("#7c5c48"),
	Color("#6f5446"),
	Color("#655d59"),
	Color("#726f72"),
	Color("#e4b570"),
	Color("#ffc18e"),
	Color("#ffdfbf"),
	Color("#bb6261"),
	Color("#fe6261"),
	Color("#678692"),
	Color("#ff9f94"),
	Color("#726e4f"),
	Color("#948c3e"),
	Color("#ff9600")
]

var armor_indices: Array = [
	[0,0,0,0,0],
	[0,0,0,0,0]
]


func _ready():
	game_options.item_selected.connect(_on_game_changed)
	room_options.item_selected.connect(_on_room_changed)
	options_dropdown.get_popup().index_pressed.connect(_on_options_selected)
	quit_button.pressed.connect(_on_quit_pressed)

	for index in armor_icons.size():
		tab_container.set_tab_title(index, "")
		tab_container.set_tab_icon(index, armor_icons[index])

	female_check.pressed.connect(_on_gender_changed)
	male_check.pressed.connect(_on_gender_changed)

	f_face_options.item_selected.connect(_on_face_selected)
	m_face_options.item_selected.connect(_on_face_selected)

	f_hair_options.item_selected.connect(_on_hair_selected)
	m_hair_options.item_selected.connect(_on_hair_selected)

	var f_color_picker: ColorPicker = f_hair_color.get_picker()
	var m_color_picker: ColorPicker = m_hair_color.get_picker()
	for color in HAIR_COLORS:
		f_color_picker.add_preset(color)
		m_color_picker.add_preset(color)

	f_hair_color.color_changed.connect(_on_hair_color_changed)
	m_hair_color.color_changed.connect(_on_hair_color_changed)

	sword_check.pressed.connect(_on_hunter_class_changed)
	gun_check.pressed.connect(_on_hunter_class_changed)

	set_zenni(armor_indices[ArmorData.Gender.FEMALE])


func _on_armor_selected(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int):
	armor_indices[gender][armor_category] = armor_index
	stats_container.set_stats(armor_indices[gender])
	var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]
	stats_container.set_rarity_color(armor_category, armor_piece.get("rarity", 0))

	if game_version == ArmorData.Game.MH1:
		var armor_skills: Array = ArmorData.get_armor_set_skills_1(armor_indices[gender])
		set_active_skills(armor_skills)
	else:
		var armor_skills: Dictionary = ArmorData.get_armor_set_skills_g(armor_indices[gender])
		set_active_skills(armor_skills.activated_skills)
		set_skill_points(armor_skills.skill_points)

	var materials: Dictionary = ArmorData.get_armor_materials(armor_indices[gender])
	set_materials(materials)

	set_zenni(armor_indices[gender])

func _on_face_selected(face_index: int):
	face_changed.emit(get_gender(), face_index)


func _on_game_changed(game_index: int):
	ArmorData.set_game(game_index)
	toggle_game_elements()
	toggle_armor_rows()


func _on_gender_changed():
	var gender: ArmorData.Gender = get_gender()

	match gender:
		ArmorData.Gender.FEMALE:
			f_face_options.show()
			m_face_options.hide()
			f_hair_options.show()
			m_hair_options.hide()
			f_hair_color.show()
			m_hair_color.hide()
		ArmorData.Gender.MALE:
			f_face_options.hide()
			m_face_options.show()
			f_hair_options.hide()
			m_hair_options.show()
			f_hair_color.hide()
			m_hair_color.show()

	toggle_armor_rows()

	gender_changed.emit(gender)


func _on_hair_color_changed(new_color: Color):
	hair_color_changed.emit(get_gender(), new_color)


func _on_hair_selected(hair_index: int):
	hair_changed.emit(get_gender(), hair_index)


func _on_hunter_class_changed():
	toggle_armor_rows()


func _on_options_selected(option_index: int):
	match option_index:
		Option.AUDIO:
			$AudioOptions.popup_centered()


func _on_quit_pressed():
	get_tree().quit()


func _on_room_changed(room_index: int):
	room_changed.emit(room_index)


func add_armor_row(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int, armor_data) -> Control:
	var armor_piece

	match armor_category:
		ArmorData.Category.HAIR:
			armor_piece = hair_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.BODY:
			armor_piece = body_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.ARMS:
			armor_piece = arms_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.WAIST:
			armor_piece = waist_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		ArmorData.Category.LEGS:
			armor_piece = legs_table.add_armor_row(game_version, armor_category, gender, armor_index, armor_data)
		_:
			return null

	armor_piece.armor_selected.connect(_on_armor_selected)
	return armor_piece


func get_gender() -> ArmorData.Gender:
	return ArmorData.Gender.FEMALE if female_check.is_pressed() else ArmorData.Gender.MALE


func get_hair_color(gender: ArmorData.Gender) -> Color:
	match gender:
		ArmorData.Gender.FEMALE:
			return f_hair_color.get_pick_color()
		ArmorData.Gender.MALE:
			return m_hair_color.get_pick_color()

	print("Invalid gender for hair color", gender)
	return Color("#000000")


func get_hunter_class() -> ArmorData.HunterClass:
	return ArmorData.HunterClass.SWORD if sword_check.is_pressed() else ArmorData.HunterClass.GUN


func set_active_skills(skill_names: Array):
	for child in active_skill_container.get_children():
		child.queue_free()

	for skill_name in skill_names:
		var skill_label: Label = Label.new()
		skill_label.set_text(skill_name)
		active_skill_container.add_child(skill_label)


func set_materials(materials):
	for material_row in material_rows.get_children():
		var material_name: String = material_row.get_material_name()
		if materials.has(material_name):
			material_row.set_materials(materials[material_name])
			materials[material_name].updated = true
		else:
			material_row.queue_free()

	for material_name in materials:
		if not materials[material_name].get("updated", false):
			var material_row = material_row_scene.instantiate()
			material_row.set_material_name(material_name)
			material_row.set_materials(materials[material_name])
			material_rows.add_child(material_row)


func set_skill_points(skill_points):
	for skill_row in skill_rows.get_children():
		var skill_name: String = skill_row.get_skill_name()
		if skill_points.has(skill_name):
			skill_row.set_skill_points(skill_points[skill_name])
			skill_points[skill_name].updated = true
		else:
			skill_row.queue_free()

	for skill_name in skill_points:
		if not skill_points[skill_name].get("updated", false):
			var skill_row = skill_row_scene.instantiate()
			skill_row.set_skill_name(skill_name)
			skill_row.set_skill_points(skill_points[skill_name])
			skill_rows.add_child(skill_row)


func set_zenni(gendered_armor_indices: Array):
	var forge_zenni: Array = []
	var buy_zenni: Array = []
	var total_forge: int = 0
	var total_buy: int = 0

	for armor_category in gendered_armor_indices.size():
		var armor_piece = ArmorData.ARMOR[ArmorData.game_version][armor_category][gendered_armor_indices[armor_category]]
		var forge: int = armor_piece.get("forge", 0)
		if forge == 0:
			forge_zenni.push_back("")
		else:
			forge_zenni.push_back(str(forge) + "z")
			total_forge += forge

		var buy: int = armor_piece.get("buy", 0)
		if buy == 0:
			buy_zenni.push_back("")
		else:
			buy_zenni.push_back(str(buy) + "z")
			total_buy += buy

	if total_forge == 0:
		forge_zenni.push_back("")
	else:
		forge_zenni.push_back(str(total_forge) + "z")

	forge_row.set_zenni(forge_zenni)

	if total_buy == 0:
		buy_zenni.push_back("")
	else:
		buy_zenni.push_back(str(total_buy) + "z")

	buy_row.set_zenni(buy_zenni)


func toggle_armor_rows():
	var gender: ArmorData.Gender = get_gender()
	var hunter_class: ArmorData.HunterClass = get_hunter_class()

	var scene_tree: SceneTree = get_tree()
	match gender:
		ArmorData.Gender.FEMALE:
			for f_armor_row in scene_tree.get_nodes_in_group("f_armor_rows"):
				f_armor_row.toggle_by_filters(hunter_class)
			for m_armor_row in scene_tree.get_nodes_in_group("m_armor_rows"):
				m_armor_row.hide()
		ArmorData.Gender.MALE:
			for f_armor_row in scene_tree.get_nodes_in_group("f_armor_rows"):
				f_armor_row.hide()
			for m_armor_row in scene_tree.get_nodes_in_group("m_armor_rows"):
				m_armor_row.toggle_by_filters(hunter_class)


func toggle_game_elements():
	var show_mhg_elements: bool = ArmorData.game_version == ArmorData.Game.MHG
	var scene_tree: SceneTree = get_tree()
	for node in scene_tree.get_nodes_in_group("mhg_elements"):
		node.set_visible(show_mhg_elements)
