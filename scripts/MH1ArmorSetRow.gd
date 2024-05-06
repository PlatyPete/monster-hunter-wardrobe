extends HBoxContainer

signal armor_button_pressed(set_index: int)

var set_index: int


func _ready():
	$ArmorButton.pressed.connect(_on_armor_pressed)


func _on_armor_pressed():
	armor_button_pressed.emit(set_index)


func set_armor_details(armor_set_index: int):
	set_index = armor_set_index

	var armor_list: PackedStringArray
	for armor_name in ArmorData.SKILL_SETS[armor_set_index].armor:
		if armor_name:
			armor_list.append(TranslationServer.translate(armor_name))

	$ArmorButton.set_text(", ".join(armor_list))

	var skill_list: PackedStringArray
	for skill_name in ArmorData.SKILL_SETS[armor_set_index].skills:
		skill_list.append(TranslationServer.translate(skill_name))

	$Skills.set_text(", ".join(skill_list))