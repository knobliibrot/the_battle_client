extends Node

signal start_open_game

func _on_StartOpenGameButton_pressed():
	emit_signal("start_open_game")
