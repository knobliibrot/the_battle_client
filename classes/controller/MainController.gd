extends Node

class_name MainController

const OPEN_GAME_SCENE: PackedScene = preload("res://classes/scenes/OpenGameScene.tscn")
const OPEN_MIRRORED_GAME_SCENE: PackedScene = preload("res://classes/scenes/OpenMirroredGameScene.tscn")
const MENU_SCENE: PackedScene = preload("res://classes/scenes/MenuScene.tscn")
const MULTIPLAYER_GAME_SCENE: PackedScene = preload("res://classes/scenes/MultiplayerGameScene.tscn")

var act_scene: ScreenScene 

func _ready():
	act_scene = get_node("ActualScene")
	call_deferred("change_to_menu_scene")

func change_to_menu_scene() -> void:
	change_scene(MENU_SCENE)
	var _err = act_scene.connect("start_open_game", self, "on_MenuScene_start_open_game")
	var _err2 = act_scene.connect("start_open_mirrored_game", self, "on_MenuScene_start_open_mirrored_game")
	var _err3 = act_scene.connect("start_multiplayer_game", self, "on_MenuScene_start_multiplayer_game")

func change_to_open_game_scene() -> void:
	change_scene(OPEN_GAME_SCENE)
	var _err = act_scene.connect("ready_to_close", self, "on_GameScene_ready_to_close")

func change_to_open_mirrored_game_scene() -> void:
	change_scene(OPEN_MIRRORED_GAME_SCENE)
	var _err = act_scene.connect("ready_to_close", self, "on_GameScene_ready_to_close")

func change_to_multiplayer_game_scene() -> void:
	change_scene(MULTIPLAYER_GAME_SCENE)
	var _err = act_scene.connect("ready_to_close", self, "on_GameScene_ready_to_close")

# Changes the actual Scene to given scene
func change_scene(new_scene) -> void:
	var new_node: ScreenScene = new_scene.instance()
	remove_child(act_scene)
	add_child(new_node)
	act_scene = new_node

func on_MenuScene_start_open_game() -> void:
	change_to_open_game_scene()

func on_MenuScene_start_open_mirrored_game() -> void:
	change_to_open_mirrored_game_scene()

func on_MenuScene_start_multiplayer_game() -> void:
	change_to_multiplayer_game_scene()

func on_GameScene_ready_to_close() -> void:
	change_to_menu_scene()
