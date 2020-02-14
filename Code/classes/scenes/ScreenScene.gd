extends Node

class_name ScreenScene

signal start_open_game

const SETTINGS_SCENE: PackedScene = preload("res://classes/game/controller/settings/SettingsWindow.tscn")

func _on_StartOpenGameButton_pressed() -> void:
	emit_signal("start_open_game")

# Instance the Settings Window
func _on_ChangeGameSettingsButton_pressed() -> void:
	var settings: Node = SETTINGS_SCENE.instance()
	var _err = settings.connect("close", self, "_on_SettingsWindow_close")
	add_child(settings)

func _on_SettingsWindow_close(window: Node) -> void:
	remove_child(window)
