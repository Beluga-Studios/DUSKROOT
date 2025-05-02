extends CharacterBody2D

@export var move_speed := 200.0

@onready var anim_sprite := $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * move_speed
	move_and_slide()

	_update_animation(input_vector)

func _update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		anim_sprite.animation = "idle"
		anim_sprite.play()
		return

	if abs(direction.x) > abs(direction.y):
		# Horizontal movement
		anim_sprite.animation = "right" if direction.x > 0 else "left"
	else:
		# Vertical movement
		anim_sprite.animation = "down" if direction.y > 0 else "up"

	anim_sprite.play()
