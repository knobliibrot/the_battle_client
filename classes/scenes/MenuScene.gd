extends "res://classes/scenes/ScreenScene.gd"


signal start_open_game
signal start_open_mirrored_game
signal start_open_network

const SETTINGS_SCENE: PackedScene = preload("res://classes/game/view/windows/settings/SettingsWindow.tscn")

func _on_StartOpenGameButton_pressed() -> void:
	emit_signal("start_open_game")

func _on_StartOpenMirroredGameButton_pressed() -> void:
	emit_signal("start_open_mirrored_game")

# Instance the Settings Window
func _on_ChangeGameSettingsButton_pressed() -> void:
	var settings: Node = SETTINGS_SCENE.instance()
	var _err = settings.connect("close", self, "_on_SettingsWindow_close")
	add_child(settings)

func _on_SettingsWindow_close(window: Node) -> void:
	remove_child(window)

#TODO
func _on_CheckNetworkButton_pressed():
	emit_signal("start_open_network")
