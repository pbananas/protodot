extends Node

const SAVE_DIR := "user://saves/"
const SAVE_FILE := "save"
const SAVE_ENC := "MJJrFM1OHVbvMyU"

var data:Dictionary = {}

func _ready() -> void:
	DirAccess.make_dir_absolute(SAVE_DIR)

func store(object:Object, property:String, value:Variant) -> void:
	data[_prop_path(object, property)] = _serialize_value(value)

func restore(object:Object, property:String, default:Variant) -> Variant:
	var prop_path:String = _prop_path(object, property)
	if prop_path in data:
		return _deserialize_value(data[prop_path])
	else:
		return default

func _prop_path(object:Object, prop:String) -> String:
	var parts:Array[String] = [object.name, prop]
	return ".".join(parts)

func _deserialize_value(value:Variant) -> Variant:
	if value is Dictionary and "__type" in value:
		if value.__type == "Vector2":
			return Vector2(value.x, value.y)
		else:
			assert(false, "Unsupported type...? " + str(value))
			return null
	else:
		return value

func _serialize_value(value:Variant) -> Variant:
	if value is Vector2:
		return { "__type": "Vector2", "x": value.x, "y": value.y }
	else:
		return value


func write_save() -> void:
	var w := _open_file(FileAccess.WRITE)

	if w == null:
		print(FileAccess.get_open_error())
		return

	var json_payload := JSON.stringify(data, "  ")
	w.store_string(json_payload)
	w.close()

func load_save() -> void:
	if not FileAccess.file_exists(_save_file_path()):
		# no save data yet
		return

	var w := _open_file(FileAccess.READ)

	if w == null:
		# couldnt read save file, just pretend we
		# didn't see anything
		return

	var json_payload := w.get_as_text()
	w.close()

	var loaded_data:Dictionary = JSON.parse_string(json_payload)
	if loaded_data == null:
		# oh well
		return

	print("LOADED DATA: ", loaded_data)
	data = loaded_data

func _open_file(mode) -> FileAccess:
	if Config.DEBUG:
		return FileAccess.open(_save_file_path(), mode)
	else:
		return FileAccess.open_encrypted_with_pass(_save_file_path(), mode, SAVE_ENC)

func _save_file_path() -> String:
	var ext:String = ".json" if Config.DEBUG else ".enc"
	return SAVE_DIR + SAVE_FILE + ext
