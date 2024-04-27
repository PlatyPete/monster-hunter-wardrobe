extends Control

signal face_changed(gender: ArmorData.Gender, face_index: int)
signal gender_changed(gender: ArmorData.Gender)
signal hair_changed(gender: ArmorData.Gender, )
signal hair_color_changed(gender: ArmorData.Gender, hair_color: Color)

@export var game_options: OptionButton
@export var female_check: CheckBox
@export var male_check: CheckBox
@export var stats_container: Control
@export var active_skill_container: VBoxContainer

@export_group("Female Options")
@export var f_face_options: OptionButton
@export var f_hair_options: OptionButton
@export var f_hair_color: ColorPickerButton

@export_group("Male Options")
@export var m_face_options: OptionButton
@export var m_hair_options: OptionButton
@export var m_hair_color: ColorPickerButton

@export_group("Armor Tables")
@export var hair_table: Control
@export var body_table: Control
@export var arms_table: Control
@export var waist_table: Control
@export var legs_table: Control

@export_group("Class Options")
@export var sword_check: CheckBox
@export var gun_check: CheckBox

@export_group("Icons")
@export var tab_container: TabContainer
@export var armor_icons: Array[Texture2D]

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


func _on_armor_selected(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int):
	armor_indices[gender][armor_category] = armor_index
	stats_container.set_stats(armor_indices[gender])
	var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]
	stats_container.set_rarity_color(armor_category, armor_piece.get("rarity", 0))

	if game_version == ArmorData.Game.MH1:
		var armor_skills: Array = ArmorData.get_armor_set_skills_1(armor_indices[ArmorData.Game.MH1])
		set_active_skills(armor_skills)

func _on_face_selected(face_index: int):
	face_changed.emit(get_gender(), face_index)


func _on_game_changed(game_index: int):
	ArmorData.set_game(game_index)
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
