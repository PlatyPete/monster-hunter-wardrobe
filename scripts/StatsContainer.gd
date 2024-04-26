extends Control

@export var armor_labels: Array[Label]
@export var armor_icons: Array[TextureRect]
@export var defense_label: Label
@export var resistance_labels: Array[Label]


func set_rarity_color(armor_category: ArmorData.Category, rarity: int):
	var rarity_color: Color = ArmorData.get_rarity_color(rarity)
	armor_icons[armor_category].set_modulate(rarity_color)
	armor_labels[armor_category].set_modulate(rarity_color)


func set_stats(armor_indices: Array):
	var defense: int = 0
	var resistances: Array[int] = [0,0,0,0,0]

	for category_index in armor_labels.size():
		var armor_piece = ArmorData.ARMOR[ArmorData.game_version][category_index][armor_indices[category_index]]

		armor_labels[category_index].set_text(armor_piece.name)
		defense += armor_piece.get("def", 0)
		var armor_resistances = armor_piece.get("res", [0,0,0,0])
		for res_index in ArmorData.Element.COUNT:
			resistances[res_index] += armor_resistances[res_index]

	defense_label.set_text(str(defense))
	for res_index in ArmorData.Element.COUNT:
		resistance_labels[res_index].set_text(str(resistances[res_index]))
