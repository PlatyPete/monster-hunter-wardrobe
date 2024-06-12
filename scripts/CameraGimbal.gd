extends Node3D

@onready var camera = $Camera3D

const offset: float = -0.5


func move_for_ui(ui_on: bool):
	if ui_on:
		camera.position.x = offset
	else:
		camera.position.x = 0.0