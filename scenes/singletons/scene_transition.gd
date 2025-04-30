extends Node

var fade_rect: ColorRect
var target_scene: String
var fade_time := 0.5

func _ready():
	# Create overlay GUI
	var canvas = CanvasLayer.new()
	canvas.layer = 100  # Ensure it's on top
	add_child(canvas)

	fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK
	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	fade_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fade_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	fade_rect.modulate.a = 0.0  # Start transparent
	canvas.add_child(fade_rect)

func fade_scene_to_file(scene_path: String, wait_time: float = 0.5):
	target_scene = scene_path
	fade_time = wait_time

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete():
	get_tree().change_scene_to_file(target_scene)
	await get_tree().process_frame

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, fade_time)
