extends Node

enum Style { PS2, AUTO }

const AUDIO_SETTING_KEYS: Array[String] = [
	"master_volume",
	"master_mute",
	"music_volume",
	"music_mute",
	"sound_volume",
	"sound_mute"
]
const HUNTER_GENDER_CATEGORIES: Array[String] = [ "hunter_f", "hunter_m" ]
const HUNTER_SETTING_KEYS: Array[String] = [
	"face",
	"hair",
	"hair_color",
	"armor_indices"
]
const SAVE_FILE_PATH: String = "user://save.cfg"


func _ready():
	var project_override: ConfigFile = ConfigFile.new()
	var file_path: String = ProjectSettings.get_setting("application/config/project_settings_override")
	if project_override.load(file_path) != OK:
		# Set defaults and save config file
		project_override.save(file_path)


func get_style_setting() -> Style:
	if ProjectSettings.get_setting("display/window/stretch/mode") == "disabled":
		return Style.AUTO

	return Style.PS2


func load_user_data(category: String = "") -> Dictionary:
	# Initialize the categories as empty Dictionaries, so we use the default values in the controls
	var user_data: Dictionary = {
		"general": {
			"room_name": "kokoto_house"
		},
		"armor_sets": {},
		"audio": {},
		"hunter": {}
	}
	for gender in ArmorData.Gender.BOTH:
		user_data[HUNTER_GENDER_CATEGORIES[gender]] = {}
		user_data.armor_sets[HUNTER_GENDER_CATEGORIES[gender]] = []

	var save_file: ConfigFile = ConfigFile.new()
	var load_error = save_file.load(SAVE_FILE_PATH)
	if load_error == OK:
		if save_file.has_section_key("general", "room_name"):
			user_data.general.room_name = save_file.get_value("general", "room_name")
		if save_file.has_section_key("general", "game_version"):
			user_data.general.game_version = save_file.get_value("general", "game_version")

		for setting_key in AUDIO_SETTING_KEYS:
			if save_file.has_section_key("audio", setting_key):
				user_data.audio[setting_key] = save_file.get_value("audio", setting_key)

		if save_file.has_section_key("hunter", "gender"):
			user_data.hunter.gender = save_file.get_value("hunter", "gender")
		if save_file.has_section_key("hunter", "hunter_class"):
			user_data.hunter.hunter_class = save_file.get_value("hunter", "hunter_class")

		for gender in ArmorData.Gender.BOTH:
			for setting_key in HUNTER_SETTING_KEYS:
				if save_file.has_section_key(HUNTER_GENDER_CATEGORIES[gender], setting_key):
					user_data[HUNTER_GENDER_CATEGORIES[gender]][setting_key] = save_file.get_value(HUNTER_GENDER_CATEGORIES[gender], setting_key)

			if save_file.has_section_key("armor_sets", HUNTER_GENDER_CATEGORIES[gender]):
				user_data.armor_sets[HUNTER_GENDER_CATEGORIES[gender]] = save_file.get_value("armor_sets", HUNTER_GENDER_CATEGORIES[gender])

	if category.length() != 0:
		return user_data.get(category, {})

	return user_data


func save_video_settings(settings: Dictionary):
	var project_override: ConfigFile = ConfigFile.new()
	var file_path: String = ProjectSettings.get_setting("application/config/project_settings_override")

	if project_override.load(file_path) != OK:
		# The file has been corrupted or deleted since the app started
		return

	if settings.has("style"):
		var window_size: Vector2i = DisplayServer.window_get_size()

		match settings.style:
			Style.PS2:
				# PS2 is the default Style setting, so we favor the defaults
				if project_override.has_section_key("display", "window/stretch/mode"):
					project_override.erase_section_key("display", "window/stretch/mode")

				project_override.set_value("display", "window/size/window_width_override", window_size.x)
				project_override.set_value("display", "window/size/window_height_override", window_size.y)
			Style.AUTO:
				project_override.set_value("display", "window/stretch/mode", "disabled")
				project_override.set_value("display", "window/size/window_width_override", window_size.x)
				project_override.set_value("display", "window/size/window_height_override", window_size.y)

	project_override.save(file_path)


func save_user_data(settings: Dictionary):
	var save_file: ConfigFile = ConfigFile.new()
	save_file.load(SAVE_FILE_PATH)

	if settings.has("general"):
		if settings.general.has("room_name"):
			save_file.set_value("general", "room_name", settings.general.room_name)
		if settings.general.has("game_version"):
			save_file.set_value("general", "game_version", settings.general.game_version)

	if settings.has("audio"):
		for setting_key in AUDIO_SETTING_KEYS:
			save_file.set_value("audio", setting_key, settings.audio[setting_key])

	if settings.has("hunter"):
		if settings.hunter.has("gender"):
			save_file.set_value("hunter", "gender", settings.hunter.gender)
		if settings.hunter.has("hunter_class"):
			save_file.set_value("hunter", "hunter_class", settings.hunter.hunter_class)

		for gender in ArmorData.Gender.BOTH:
			if settings.hunter.has(HUNTER_GENDER_CATEGORIES[gender]):
				var hunter_settings = settings.hunter[HUNTER_GENDER_CATEGORIES[gender]]
				for setting_key in HUNTER_SETTING_KEYS:
					if hunter_settings.has(setting_key):
						save_file.set_value(HUNTER_GENDER_CATEGORIES[gender], setting_key, hunter_settings[setting_key])

	if settings.has("armor_sets"):
		for gender in ArmorData.Gender.BOTH:
			save_file.set_value("armor_sets", HUNTER_GENDER_CATEGORIES[gender], settings.armor_sets[HUNTER_GENDER_CATEGORIES[gender]])

	save_file.save(SAVE_FILE_PATH)
