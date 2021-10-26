extends "res://classes/scenes/ScreenScene.gd"

signal game_over

var game_finished: bool = false

# TODO game logic for open mode
func _ready():
	pass
#TODO should be in open game scene
func run_open_game(mirrored: bool) -> bool:
	var player1: Player = Player.new()
	player1.init(PlayerType.MANUAL, true)
	var player2: Player = Player.new()
	player2.init(PlayerType.MANUAL, false)
	$Content/Playground/Gamelogic.initialize_game(player1, player2)
	$Content/Playground/Gamelogic.generate_battlefield(mirrored)
	
	$Content/Playground/Gamelogic.start_initial_mode(true)
	yield($Content/Playground/Gamelogic, "initial_done")
	if self.game_finished:
		emit_signal("game_over")
		return true
	$Content/Playground/Gamelogic.start_initial_mode(false)
	yield($Content/Playground/Gamelogic, "initial_done")
	if self.game_finished:
		emit_signal("game_over")
		return true
	self.game_finished = false
	var round_timer: int = 0
	$Content/Playground/Gamelogic.start_game_mode()
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
