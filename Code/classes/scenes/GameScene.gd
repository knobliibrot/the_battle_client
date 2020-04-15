extends "res://classes/scenes/ScreenScene.gd"

signal game_over

# TODO game logic for open mode
func _ready():
	$Content/Playground/Gamelogic.initialize_game(PlayerType.MANUAL, PlayerType.MANUAL)
	$Content/Playground/Gamelogic.generate_battelfield()
	
	$Content/Playground/Gamelogic.start_castel_choosing(true)
	yield($Content/Playground/Gamelogic, "castle_set")
	$Content/Playground/Gamelogic.start_castel_choosing(false)
	yield($Content/Playground/Gamelogic, "castle_set")
	
	var round_timer: int = 0
	var game_finished: bool = false
	while(!game_finished):
		$Content/Playground/Gamelogic.start_turn(true, round_timer)
		game_finished = yield($Content/Playground/Gamelogic, "turn_finished")
		print("Round " + str(round_timer) + ", Player 1; finished")
		if !game_finished:
			$Content/Playground/Gamelogic.start_turn(false, round_timer)
			game_finished = yield($Content/Playground/Gamelogic, "turn_finished")
			print("Round " + str(round_timer) + ", Player 2; finished")
		round_timer += 1
	
	emit_signal("game_over")



