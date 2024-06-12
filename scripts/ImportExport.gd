extends AcceptDialog

signal armor_code_imported(armor_code: Array)

@export var export_field: LineEdit
@export var export_button: Button
@export var import_field: LineEdit
@export var import_button: Button

var armor_code_regex: RegEx = RegEx.new()


func _ready():
	armor_code_regex.compile("^[0-1],[0-2],[0-2],\\d{1,3},\\d{1,3},\\d{1,3},\\d{1,3},\\d{1,3}$")

	export_button.pressed.connect(_on_export_pressed)
	import_button.pressed.connect(_on_import_pressed)


func _on_export_pressed():
	DisplayServer.clipboard_set(export_field.get_text())
	hide()


func _on_import_pressed():
	var armor_code: Array = parse_armor_code(import_field.get_text())
	if is_code_valid(armor_code):
		armor_code_imported.emit(armor_code)
		hide()


func is_code_valid(armor_code: Array) -> bool:
	if armor_code.size() != 8:
		print("Armor code is not eight digits long", armor_code)
		return false

	for index in ArmorData.CATEGORY_COUNT:
		if armor_code[3 + index] >= ArmorData.ARMOR[armor_code[0]][index].size():
			print("Invalid digits (%d) for category %d" % [armor_code[3 + index], index])
			return false

	return true


func parse_armor_code(armor_code_string: String) -> Array:
	if !armor_code_regex.search(armor_code_string):
		print("code format is invalid")
		return Array([])

	return Array(armor_code_string.split(",")).map(func(digit): return int(digit))


func set_export_code(export_code: Array[int]):
	export_field.set_text(",".join(export_code))
