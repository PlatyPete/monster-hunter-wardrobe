extends Node

@export var room: Node3D

var game_version: ArmorData.Game = ArmorData.Game.MH1


func _ready():
	var hunters = $HunterContainer.get_children()
	for gender_index in ArmorData.Gender.BOTH:
		for armor_category in ArmorData.ARMOR[game_version].size():
			var armor_index: int = 0
			for armor_piece in ArmorData.ARMOR[game_version][armor_category]:
				# Only add an armor row if this armor piece is valid for the current gender
				if not armor_piece.has("gender") or armor_piece.gender == gender_index:
					var armor_row = $UIController.add_armor_row(ArmorData.Game.MH1, armor_category, ArmorData.Gender.FEMALE, armor_index, armor_piece)
					if armor_row:
						armor_row.armor_selected.connect(hunters[gender_index].equip_armor)
					else:
						# If we pass an invalid armor category to the add_armor_row method, it will return null
						print("No armor row created")
						break

				armor_index += 1

	# TODO: get room to load from save file
	load_room("kokoto_house")


func load_room(room_name: String):
	room.queue_free()
	room = ($ResourcePreloader.get_resource(room_name)).instantiate()
	add_child(room)

	$CameraGimbal.rotation.y = room.player_position.rotation.y
	room.position = -room.player_position.position
	$HunterContainer.rotation = room.player_position.rotation
