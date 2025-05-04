extends Node

@export var player_scene: PackedScene

var player_instance: Node = null

func spawn_player(parent: Node):
	if player_instance:
		player_instance.queue_free()

	player_instance = player_scene.instantiate()
	parent.add_child(player_instance)
