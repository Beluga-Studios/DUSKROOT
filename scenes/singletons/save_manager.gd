extends Node

const SAVE_DIR := "user://saves/"
const MAX_SLOTS := 3  # Adjust as needed

var save_data := {
	"name": "Player",
	"hp": 20,
	"lv": 1,
	"exp": 0,
	"position": Vector2(0, 0),
	"flags": {},
	"location": "Ruins",
	"play_time": 0  # Seconds played
}

func _ready():
	# Ensure the save directory exists
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")

func get_save_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d.save" % slot

func save_game(slot: int) -> void:
	var path = get_save_path(slot)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(str(save_data))
		file.close()
		print("Game saved to slot %d." % slot)
	else:
		print("Failed to save game to slot %d." % slot)

func load_game(slot: int) -> void:
	var path = get_save_path(slot)
	if not FileAccess.file_exists(path):
		print("No save file found in slot %d." % slot)
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		save_data = JSON.parse_string(data)
		file.close()
		print("Game loaded from slot %d." % slot)
	else:
		print("Failed to load game from slot %d." % slot)

func delete_save(slot: int) -> void:
	var path = get_save_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("Save in slot %d deleted." % slot)
	else:
		print("No save file to delete in slot %d." % slot)

func list_save_slots() -> Array:
	var slots = []
	for i in range(1, MAX_SLOTS + 1):
		var path = get_save_path(i)
		if FileAccess.file_exists(path):
			slots.append(i)
	return slots

func set_flag(flag_name: String, value: bool = true):
	save_data["flags"][flag_name] = value

func get_flag(flag_name: String) -> bool:
	return save_data["flags"].get(flag_name, false)

func set_position(pos: Vector2):
	save_data["position"] = pos

func get_position() -> Vector2:
	return save_data["position"]

func format_time(seconds: int) -> String:
	var hrs = seconds / 3600
	var mins = (seconds % 3600) / 60
	var secs = seconds % 60
	return "%02d:%02d:%02d" % [hrs, mins, secs]

func get_save_slot_summary(slot: int) -> Dictionary:
	var path = get_save_path(slot)
	if not FileAccess.file_exists(path):
		return {}  # Slot is empty

	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()

		return {
			"slot": slot,
			"name": data.get("name", "Unknown"),
			"location": data.get("location", "Unknown"),
			"play_time": format_time(data.get("play_time", 0))
		}
	else:
		return {}  # Could not open file

func list_all_slot_summaries() -> Array:
	var summaries = []
	for i in range(1, MAX_SLOTS + 1):
		var summary = get_save_slot_summary(i)
		if summary:
			summaries.append(summary)
	return summaries
