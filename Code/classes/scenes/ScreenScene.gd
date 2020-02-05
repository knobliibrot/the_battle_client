extends Node

class_name ScreenScene

signal start_open_game

const SETTINGS_SCENE: PackedScene = preload("res://classes/game/controller/settings/SettingsWindow.tscn")

func _on_StartOpenGameButton_pressed():
	emit_signal("start_open_game")


func _on_ChangeGameSettingsButton_pressed():
	add_child(SETTINGS_SCENE.instance())
