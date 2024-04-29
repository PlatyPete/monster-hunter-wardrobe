extends ConfirmationDialog

@export var master_volume: Slider
@export var master_mute: CheckBox
@export var music_volume: Slider
@export var music_mute: CheckBox
@export var sound_volume: Slider
@export var sound_mute: CheckBox

var preserved_master_volume: float
var preserved_master_mute: bool
var preserved_music_volume: float
var preserved_music_mute: bool
var preserved_sound_volume: float
var preserved_sound_mute: bool


func _ready():
	about_to_popup.connect(preserve_settings)
	canceled.connect(reset_settings)

	master_volume.value_changed.connect(_on_master_volume_changed)
	master_mute.toggled.connect(_on_master_mute_pressed)
	music_volume.value_changed.connect(_on_music_volume_changed)
	music_mute.toggled.connect(_on_music_mute_pressed)
	sound_volume.value_changed.connect(_on_sound_volume_changed)
	sound_mute.toggled.connect(_on_sound_mute_pressed)


func _on_master_mute_pressed(toggled_on: bool):
	AudioServer.set_bus_mute(0, toggled_on)


func _on_master_volume_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_mute_pressed(toggled_on: bool):
	AudioServer.set_bus_mute(1, toggled_on)


func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sound_mute_pressed(toggled_on: bool):
	AudioServer.set_bus_mute(2, toggled_on)


func _on_sound_volume_changed(value: float):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func preserve_settings():
	preserved_master_volume = master_volume.get_value()
	preserved_master_mute = master_mute.is_pressed()
	preserved_music_volume = music_volume.get_value()
	preserved_music_mute = music_mute.is_pressed()
	preserved_sound_volume = sound_volume.get_value()
	preserved_sound_mute = sound_mute.is_pressed()


func reset_settings():
	master_volume.set_value(preserved_master_volume)
	master_mute.set_pressed(preserved_master_mute)
	music_volume.set_value(preserved_music_volume)
	music_mute.set_pressed(preserved_music_mute)
	sound_volume.set_value(preserved_sound_volume)
	sound_mute.set_pressed(preserved_sound_mute)
