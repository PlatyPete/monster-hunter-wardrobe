extends Control

signal armor_set_pressed(armor_indices: Array)
signal overwrite_pressed

var armor_indices: Array = [0,0,0,0,0]


func _ready():
	$EquipButton.pressed.connect(_on_set_pressed)
	$OverwriteButton.pressed.connect(_on_overwrite_pressed)
	$DeleteButton.pressed.connect(delete_set)


func _on_set_pressed():
	armor_set_pressed.emit(armor_indices)


func _on_overwrite_pressed():
	overwrite_pressed.emit()


func delete_set():
	queue_free()


func set_armor(new_armor_indices: Array):
	armor_indices = new_armor_indices


func set_set_name(new_name: String):
	$SetName.set_text(new_name)
