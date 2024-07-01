extends Window

signal armor_set_pressed(armor_set_index: int)

@export var armor_sets_container: VBoxContainer
@export var armor_set_row_scene: PackedScene


func _ready():
	for armor_set_index in ArmorData.SKILL_SETS.size():
		var armor_set_row = armor_set_row_scene.instantiate()
		armor_set_row.set_armor_details(armor_set_index)
		armor_sets_container.add_child(armor_set_row)
		armor_set_row.armor_button_pressed.connect(_on_armor_set_pressed)


func _on_armor_set_pressed(armor_set_index: int):
	armor_set_pressed.emit(armor_set_index)


func toggle_sets_by_gender(gender: ArmorData.Gender):
	var scene_tree: SceneTree = get_tree()

	var female_sets = scene_tree.get_nodes_in_group("female_sets")
	var male_sets = scene_tree.get_nodes_in_group("male_sets")

	match gender:
		ArmorData.Gender.FEMALE:
			for armor_set in female_sets:
				armor_set.show()
			for armor_set in male_sets:
				armor_set.hide()
		ArmorData.Gender.MALE:
			for armor_set in female_sets:
				armor_set.hide()
			for armor_set in male_sets:
				armor_set.show()