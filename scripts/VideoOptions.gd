extends ConfirmationDialog

@export var style_option: OptionButton

const DEFAULT_VIEWPORT_SIZE: Vector2i = Vector2i(640, 480)

var preserved_style: SaveData.Style


func _ready():
	about_to_popup.connect(preserve_settings)
	canceled.connect(reset_settings)
	confirmed.connect(save_settings)

	var style_setting: SaveData.Style = SaveData.get_style_setting()
	style_option.select(style_setting)
	style_option.item_selected.connect(_on_style_selected)


func _on_style_selected(item_index: int):
	set_style(item_index)


func preserve_settings():
	preserved_style = style_option.get_selected()


func reset_settings():
	style_option.select(preserved_style)
	set_style(preserved_style)


func save_settings():
	var settings: Dictionary = {
		"style": style_option.get_selected()
	}
	SaveData.save_video_settings(settings)


func set_style(style: SaveData.Style):
	match style:
		SaveData.Style.PS2:
			get_tree().root.set_content_scale_mode(CONTENT_SCALE_MODE_VIEWPORT)
		SaveData.Style.AUTO:
			get_tree().root.set_content_scale_mode(CONTENT_SCALE_MODE_DISABLED)
