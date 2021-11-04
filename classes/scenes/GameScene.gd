extends "res://classes/scenes/ScreenScene.gd"

signal game_over

var game_finished: bool = false

func _on_Gamelogic_play_finished():
	pass # Replace with function body.


func _on_Gamelogic_turn_finished():
	pass # Replace with function body.


func _on_Gamelogic_game_finished(player: Player):
	self.game_finished = true


func _on_Gamelogic_initial_done( selected_troops: Array, castle_position: Vector2) -> void:
	pass # Replace with function body.
