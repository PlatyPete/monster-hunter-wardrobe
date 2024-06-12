extends Node

@export var room: Node3D

const TURN_SPEED: float = 3.5
const EQUIP_SOUNDS: Array[String] = [
	"equip_0",
	"equip_1",
	"equip_2",
	"equip_3"
]
const ROOM_NAMES: Array[String] = [
	"kokoto_house",
	"pawn_room",
	"rook_room",
	"bishop_room",
	"queen_room",
	"king_room"
]

var room_name: String


func _ready():
	$UIController.armor_selected.connect(_on_armor_selected)
	$UIController.panels_toggled.connect(_on_panels_toggled)
	$UIController.room_changed.connect(_on_room_changed)

	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

	var settings = SaveData.load_user_data()

	load_room(settings.general.room_name)
	var room_index: int = ROOM_NAMES.find(settings.general.room_name)
	if room_index == -1:
		print("Room not found in ROOM_NAMES: ", settings.general.room_name)
	else:
		$UIController.room_options.select(room_index)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var video_settings: Dictionary = {
			"style": $UIController.get_video_style()
		}
		SaveData.save_video_settings(video_settings)
		get_tree().quit()


func _on_animation_finished(animation_name: String):
	match animation_name:
		"fade_to_black":
			load_room(room_name)
			$AnimationPlayer.play("fade_from_black")


func _on_armor_selected():
	play_equip_sound()


func _on_panels_toggled(panels_visible: bool):
	$CameraGimbal.move_for_ui(panels_visible)


func _on_room_changed(room_index: int):
	room_name = ROOM_NAMES[room_index]
	$AnimationPlayer.play("fade_to_black")
	room.fade_music_out()


func _process(delta: float):
	var x_vel: float = TURN_SPEED * Input.get_axis("rotate_left", "rotate_right")
	if x_vel != 0:
		$HunterContainer.rotate_y(delta * x_vel)


func load_room(new_room_name: String):
	room.queue_free()
	room = ($ResourcePreloader.get_resource(new_room_name)).instantiate()
	add_child(room)

	$CameraGimbal.rotation.y = room.player_position.rotation.y
	$CameraGimbal.move_for_ui(true)
	room.position = -room.player_position.position
	$HunterContainer.rotation = room.player_position.rotation
	room.play_music()

	var settings: Dictionary = {
		"general": {
			"room_name": new_room_name
		}
	}
	SaveData.save_user_data(settings)


func play_equip_sound():
	var equip_sound = $ResourcePreloader.get_resource(EQUIP_SOUNDS[randi() % EQUIP_SOUNDS.size()])
	$AudioStreamPlayer.set_stream(equip_sound)
	$AudioStreamPlayer.play()
