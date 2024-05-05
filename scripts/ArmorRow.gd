extends Control

signal armor_selected(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int)

var armor_category: ArmorData.Category
var armor_index: int
var game_version: int
var gender: ArmorData.Gender
var hunter_class: ArmorData.HunterClass


func _ready():
	$CheckBox.pressed.connect(_on_pressed)


func _on_pressed():
	armor_selected.emit(game_version, armor_category, gender, armor_index)


func equip_armor():
	$CheckBox.set_pressed(true)


func set_all_data(new_game_version: ArmorData.Game, new_armor_category: ArmorData.Category, new_gender: ArmorData.Gender, new_armor_index: int, armor_data):
	armor_category = new_armor_category
	gender = new_gender
	armor_index = new_armor_index
	game_version = new_game_version
	hunter_class = armor_data.get("hunter_class", ArmorData.HunterClass.BOTH)

	set_armor_name(armor_data.name)

	if armor_index != 0:
		var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]
		set_defense(str(armor_piece.def))
		for element_index in ArmorData.Element.COUNT:
			set_resistance(element_index, str(armor_piece.res[element_index]))
	else:
		set_defense("0")
		for element_index in ArmorData.Element.COUNT:
			set_resistance(element_index, "0")


func set_armor_name(new_name: String):
	$CheckBox.set_text(new_name)


func set_button_group(button_group: ButtonGroup):
	$CheckBox.set_button_group(button_group)


func set_defense(new_defense: String):
	$Defense.set_text(new_defense)


func set_resistance(element: ArmorData.Element, new_resistance: String):
	match element:
		ArmorData.Element.FIRE:
			$FireRes.set_text(new_resistance)
		ArmorData.Element.WATER:
			$WaterRes.set_text(new_resistance)
		ArmorData.Element.THUNDER:
			$ThunderRes.set_text(new_resistance)
		ArmorData.Element.DRAGON:
			$DragonRes.set_text(new_resistance)


func toggle_by_filters(active_hunter_class: ArmorData.HunterClass):
	set_visible(game_version == ArmorData.game_version and (hunter_class == ArmorData.HunterClass.BOTH or hunter_class == active_hunter_class))
