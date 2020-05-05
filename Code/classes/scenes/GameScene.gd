extends "res://classes/scenes/ScreenScene.gd"

signal game_over

var game_finished: bool

# TODO game logic for open mode
func _ready():
	run_open_game()

func run_open_game() -> bool:
	$Content/Playground/Gamelogic.initialize_game(PlayerType.MANUAL, PlayerType.MANUAL)
	$Content/Playground/Gamelogic.generate_battelfield()
	
	$Content/Playground/Gamelogic.start_castel_choosing(true)
	yield($Content/Playground/Gamelogic, "castle_set")
	if self.game_finished:
		return true
	$Content/Playground/Gamelogic.start_castel_choosing(false)
	yield($Content/Playground/Gamelogic, "castle_set")
	if self.game_finished:
		return true
	self.game_finished = false
	var round_timer: int = 0
	while(!self.game_finished):
		$Content/Playground/Gamelogic.start_turn(true, round_timer)
		yield($Content/Playground/Gamelogic, "turn_finished")
		print("Round " + str(round_timer) + ", Player 1; finished")
		if !self.game_finished:
			$Content/Playground/Gamelogic.start_turn(false, round_timer)
			yield($Content/Playground/Gamelogic, "turn_finished")
			print("Round " + str(round_timer) + ", Player 2; finished")
		round_timer += 1
	
	emit_signal("game_over")
	return true

func _on_Playground_game_finished(player: Player):
	self.game_finished = true
