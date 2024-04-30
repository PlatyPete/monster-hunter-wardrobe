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

@onready var hunters: Array = $HunterContainer.get_children()

var room_name: String


func _ready():
	for game_index in ArmorData.Game.BOTH:
		for gender_index in ArmorData.Gender.BOTH:
			for armor_category in ArmorData.ARMOR[game_index].size():
				var armor_index: int = 0
				for armor_piece in ArmorData.ARMOR[game_index][armor_category]:
					# Only add an armor row if this armor piece is valid for the current gender
					if not armor_piece.has("gender") or armor_piece.gender == gender_index:
						var armor_row = $UIController.add_armor_row(game_index, armor_category, gender_index, armor_index, armor_piece)
						if armor_row:
							armor_row.armor_selected.connect(_on_armor_selected)
						else:
							# If we pass an invalid armor category to the add_armor_row method, it will return null
							print("No armor row created")
							break

					armor_index += 1

	$UIController.face_changed.connect(_on_face_changed)
	$UIController.gender_changed.connect(_on_gender_changed)
	$UIController.hair_changed.connect(_on_hair_changed)
	$UIController.hair_color_changed.connect(_on_hair_color_changed)
	$UIController.room_changed.connect(_on_room_changed)

	$UIController.toggle_armor_rows()
	$UIController.toggle_game_elements()

	for gender in ArmorData.Gender.BOTH:
		var hair_color: Color = $UIController.get_hair_color(gender)
		hunters[gender].set_hair_color(hair_color)

	# TODO: set player customization and armor from save file

	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	# TODO: get room to load from save file
	load_room("kokoto_house")


func _on_animation_finished(animation_name: String):
	match animation_name:
		"fade_to_black":
			load_room(room_name)
			$AnimationPlayer.play("fade_from_black")


func _on_armor_selected(game_version: ArmorData.Game, armor_category: ArmorData.Category, gender: ArmorData.Gender, armor_index: int):
	hunters[gender].equip_armor(game_version, armor_category, armor_index)
	play_equip_sound()


func _on_face_changed(gender: ArmorData.Gender, face_index: int):
	hunters[gender].set_model(ArmorData.Category.FACE, face_index)


func _on_gender_changed(gender: ArmorData.Gender):
	hunters[gender].show()
	hunters[(gender + 1) % 2].hide()


func _on_hair_changed(gender: ArmorData.Gender, hair_index: int):
	hunters[gender].set_hair(hair_index)


func _on_hair_color_changed(gender: ArmorData.Gender, hair_color: Color):
	hunters[gender].set_hair_color(hair_color)


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
	room.position = -room.player_position.position
	$HunterContainer.rotation = room.player_position.rotation
	room.play_music()


func play_equip_sound():
	var equip_sound = $ResourcePreloader.get_resource(EQUIP_SOUNDS[randi() % EQUIP_SOUNDS.size()])
	$AudioStreamPlayer.set_stream(equip_sound)
	$AudioStreamPlayer.play()
