extends ConfirmationDialog

signal armor_set_pressed(armor_index: int)

@export var armor_sets_container: VBoxContainer
@export var armor_set_row_scene: PackedScene


func _ready():
	for armor_index in ArmorData.SKILL_SETS.size():
		var armor_set_row = armor_set_row_scene.instantiate()
		armor_set_row.set_armor_details(armor_index)
		armor_sets_container.add_child(armor_set_row)
		armor_set_row.armor_button_pressed.connect(_on_armor_set_pressed)


func _on_armor_set_pressed(armor_index: int):
	armor_set_pressed.emit(armor_index)
