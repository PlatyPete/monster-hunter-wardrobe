extends Control

signal armor_set_pressed(armor_indices: Array)
signal overwrite_pressed
signal set_name_changed

var armor_indices: Array = [0,0,0,0,0]
var game_version: int
var gender: ArmorData.Gender
var hunter_class: ArmorData.HunterClass


func _ready():
	$EquipButton.pressed.connect(_on_set_pressed)
	$SetName.focus_exited.connect(_on_focus_exited)
	$OverwriteButton.pressed.connect(_on_overwrite_pressed)
	$DeleteButton.pressed.connect(delete_set)


func _on_focus_exited():
	set_name_changed.emit()


func _on_overwrite_pressed():
	overwrite_pressed.emit()


func _on_set_pressed():
	armor_set_pressed.emit(armor_indices)


func delete_set():
	queue_free()


func set_armor(new_armor_indices: Array):
	armor_indices = new_armor_indices


func set_set_name(new_name: String):
	$SetName.set_text(new_name)


func to_save_format() -> Dictionary:
	return {
		"name": $SetName.get_text(),
		"armor_indices": armor_indices,
		"game_version": game_version,
		"hunter_class": hunter_class
	}


func toggle_by_filters(active_hunter_class: ArmorData.HunterClass):
	set_visible(game_version == ArmorData.game_version and (hunter_class == ArmorData.HunterClass.BOTH or hunter_class == active_hunter_class))
