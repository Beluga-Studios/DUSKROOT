extends Control

@onready var slots_container := $Slots
@onready var slot_template := $SlotTemplate

var mode := "load"  # or "save"

func _ready():
	update_slots()

func update_slots():
	#slots_container.clear()  # Remove any existing children
	
	for slot in range(1, SaveManager.MAX_SLOTS + 1):
		var summary = SaveManager.get_save_slot_summary(slot)
		
		var new_button = slot_template.duplicate()
		new_button.visible = true  # Enable the template copy

		if summary.is_empty():
			new_button.text = "Slot %d - Empty" % slot
		else:
			new_button.text = "Slot %d - %s - %s - %s" % [
				slot,
				summary.name,
				summary.location,
				summary.play_time
			]

		new_button.pressed.connect(on_slot_pressed.bind(slot))
		slots_container.add_child(new_button)

func on_slot_pressed(slot: int):
	if mode == "save":
		SaveManager.save_game(slot)
		update_slots()  # Refresh UI
	elif mode == "load":
		SaveManager.load_game(slot)
		get_tree().change_scene_to_file("res://scenes/Game.tscn")
