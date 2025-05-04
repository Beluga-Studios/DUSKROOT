extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func goto_room(room_dir:String,position:Vector2=Vector2(0,0)):
	print("is moving to room dir: ",room_dir," with player position: ",position)
	#SceneTransition.fade_scene_to_file("res://scenes/game/%s" % room_dir,0)
	get_tree().change_scene_to_file("res://scenes/game/root/taproot.tscn")
	
	#PlayerManager.spawn_player(get_tree().current_scene, Vector2(100, 200))
