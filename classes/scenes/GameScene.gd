extends "res://classes/scenes/ScreenScene.gd"

signal ready_to_close

var game_finished: bool = false

func _on_Gamelogic_initial_done( selected_troops: Array, castle_position: Vector2) -> void:
	pass # Replace with function body.

func _on_Gamelogic_turn_finished():
	pass # Replace with function body.

func _on_Gamelogic_adding_to_queue(troop_type: int):
	pass # Replace with function body.

func _on_Gamelogic_removing_from_queue(queue_pos: int):
	pass # Replace with function body.

func _on_Gamelogic_moving_troop(from: Vector2, to: Vector2):
	pass # Replace with function body.

func _on_Gamelogic_game_over(player: Player):
	pass # Replace with function body.

func _on_Gamelogic_give_up():
	pass # Replace with function body.

func _on_Gamelogic_game_finished():
	self.game_finished = true
