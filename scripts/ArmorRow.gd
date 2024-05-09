extends Control

signal armor_selected(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int)

@export var armor_category: ArmorData.Category
@export var armor_index: int
@export var game_version: int
@export var gender: ArmorData.Gender
@export var hunter_class: ArmorData.HunterClass


func _ready():
	# Since this is a packed scene, we can't use the tool script to fill in any data
	var armor_data = ArmorData.ARMOR[game_version][armor_category][armor_index]
	set_armor_name(armor_data.name)

	if armor_index != 0:
		set_defense(str(armor_data.def))
		for element_index in ArmorData.Element.COUNT:
			set_resistance(element_index, str(armor_data.res[element_index]))
	else:
		set_defense("0")
		for element_index in ArmorData.Element.COUNT:
			set_resistance(element_index, "0")

	$CheckBox.pressed.connect(_on_pressed)


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


func _on_pressed():
	armor_selected.emit(game_version, armor_category, gender, armor_index)


func equip_armor():
	$CheckBox.set_pressed(true)


func is_selected() -> bool:
	return $CheckBox.is_pressed()


func toggle_by_filters(active_hunter_class: ArmorData.HunterClass):
	set_visible(game_version == ArmorData.game_version and (hunter_class == ArmorData.HunterClass.BOTH or hunter_class == active_hunter_class))
