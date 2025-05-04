extends Node

var fade_rect: ColorRect
var target_scene: String
var fade_out_time := 0.5
var fade_in_time := 0.5

func _ready():
	# Create overlay GUI
	var canvas = CanvasLayer.new()
	canvas.layer = 100
	add_child(canvas)

	fade_rect = ColorRect.new()
	fade_rect.color = Color.BLACK  # Default fade color
	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	fade_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fade_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	fade_rect.modulate.a = 0.0
	canvas.add_child(fade_rect)

func fade_scene_to_file(
		scene_path: String,
		out_time: float = 0.5,
		in_time: float = -1.0,
		colour: Color = Color.BLACK):

	print("Chaging Scene to ",scene_path)
	target_scene = scene_path
	fade_out_time = out_time
	fade_in_time = in_time if in_time >= 0.0 else out_time

	fade_rect.color = colour

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_out_time)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete():
	get_tree().change_scene_to_file(target_scene)
	await get_tree().process_frame  # Wait for scene to fully switch

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, fade_in_time)
