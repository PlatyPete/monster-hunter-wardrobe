extends CheckBox

signal armor_selected(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int)

@export var armor_category: ArmorData.Category
@export var armor_index: int
@export var game_version: int
@export var gender: ArmorData.Gender
@export var hunter_class: ArmorData.HunterClass
@export var row_elements: Array[Node]


func _ready():
	pressed.connect(_on_pressed)
	visibility_changed.connect(_on_visibility_changed)


func _on_pressed():
	armor_selected.emit(game_version, armor_category, gender, armor_index)


func _on_visibility_changed():
	for element in row_elements:
		element.set_visible(visible)


func equip_armor():
	set_pressed(true)


func toggle_by_filters(active_hunter_class: ArmorData.HunterClass):
	var toggle_on: bool = game_version == ArmorData.game_version and (hunter_class == ArmorData.HunterClass.BOTH or hunter_class == active_hunter_class)
	set_visible(toggle_on)
