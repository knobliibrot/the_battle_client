extends Node

const GAME_SCENE = "res://classes/scenes/GameScene.tscn"

func _ready():	
	call_deferred("_change_scene", GAME_SCENE)
	
# Changes the actual Scene to given scene
func _change_scene(new_scene):
	var node = get_node("ActualScene");
	var game_scene = load(new_scene) 
	var game_node = game_scene.instance()
	node.replace_by(game_node,true)
