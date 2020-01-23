extends Node

const GAME_SCENE = "res://classes/scenes/GameScene.tscn"
const MENU_SCENE = "res://classes/scenes/MenuScene.tscn"

var act_scene: Node 

func _ready():	
	act_scene = get_node("ActualScene")
	call_deferred("change_to_menu_scene")

func change_to_menu_scene() -> void:
	change_scene(MENU_SCENE)
	act_scene.connect("start_open_game", self, "on_MenuScene_start_open_game")

func change_to_open_game_scene() -> void:
	change_scene(GAME_SCENE)
	act_scene.connect("game_over", self, "on_GameScene_game_over")

# Changes the actual Scene to given scene
func change_scene(new_scene) -> void:
	var scene = load(new_scene) 
	var node = scene.instance()
	remove_child(act_scene)
	add_child(node)
	act_scene = node

func on_MenuScene_start_open_game() -> void:
	change_to_open_game_scene()

func on_GameScene_game_over() -> void:
	change_to_menu_scene()