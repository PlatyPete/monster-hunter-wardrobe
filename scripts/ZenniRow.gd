extends Control

@export var row_title: String


func _ready():
	$RowTitle.set_text(row_title)


func set_zenni(zenni: Array):
	$HairZenni.set_text(zenni[ArmorData.Category.HAIR])
	$BodyZenni.set_text(zenni[ArmorData.Category.BODY])
	$ArmsZenni.set_text(zenni[ArmorData.Category.ARMS])
	$WaistZenni.set_text(zenni[ArmorData.Category.WAIST])
	$LegsZenni.set_text(zenni[ArmorData.Category.LEGS])
	$TotalZenni.set_text(zenni[ArmorData.CATEGORY_COUNT])
