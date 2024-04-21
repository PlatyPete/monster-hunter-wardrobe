extends Control

signal armor_selected(game_version: int, armor_category: ArmorData.Category, armor_index: int)

var armor_category: ArmorData.Category
var armor_index: int
var game_version: int


func _ready():
	$CheckBox.pressed.connect(_on_pressed)


func _on_pressed():
	armor_selected.emit(game_version, armor_category, armor_index)


func set_all_data(new_game_version: ArmorData.Game, new_armor_category: ArmorData.Category, new_armor_index: int, armor_data):
	armor_category = new_armor_category
	armor_index = new_armor_index
	game_version = new_game_version
	set_armor_name(armor_data.name)

	if armor_index != 0:
		var armor_piece = ArmorData.ARMOR[game_version][armor_category][armor_index]
		set_defense(str(armor_piece.def))
		for element_index in ArmorData.Element.COUNT:
			set_resistance(element_index, str(armor_piece.res[element_index]))
	else:
		set_defense("")
		for element_index in ArmorData.Element.COUNT:
			set_resistance(element_index, "")


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
