extends Control

signal face_changed(gender: ArmorData.Gender, face_index: int)
signal gender_changed(gender: ArmorData.Gender)

@export var female_check: CheckBox
@export var male_check: CheckBox

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


func _ready():
	female_check.pressed.connect(_on_gender_changed)
	male_check.pressed.connect(_on_gender_changed)

	f_face_options.item_selected.connect(_on_face_selected)
	m_face_options.item_selected.connect(_on_face_selected)

	var f_color_picker: ColorPicker = f_hair_color.get_picker()
	var m_color_picker: ColorPicker = m_hair_color.get_picker()
	for color in HAIR_COLORS:
		f_color_picker.add_preset(color)
		m_color_picker.add_preset(color)


func _on_face_selected(face_index: int):
	face_changed.emit(get_gender(), face_index)


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

	gender_changed.emit(gender)


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


func get_gender() -> ArmorData.Gender:
	return ArmorData.Gender.FEMALE if female_check.is_pressed() else ArmorData.Gender.MALE
