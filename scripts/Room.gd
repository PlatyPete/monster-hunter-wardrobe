extends Node3D

@onready var player_position: Node3D = get_node("Player Position")


func fade_music_out():
	$AnimationPlayer.play("music_animations/fade_out")


func play_music():
	$AudioStreamPlayer.play()
