extends "res://classes/scenes/ScreenScene.gd"

signal game_over

func _ready():
	$Playground/Gamelogic.initialize_game(PlayerTypeEnum.MANUAL, PlayerTypeEnum.MANUAL)
	$Playground/Gamelogic.generate_battelfield()
	
	$Playground/Gamelogic.choose_castel(true)
	yield($Playground/Gamelogic, "castle_set")
	$Playground/Gamelogic.choose_castel(false)
	yield($Playground/Gamelogic, "castle_set")
	
	var game_finished: bool = false
	while(!game_finished):
		$Playground/Gamelogic.start_turn(true)
		game_finished = yield($Playground/Gamelogic, "turn_finished")
		if !game_finished:
			$Playground/Gamelogic.start_turn(false)
			game_finished = yield($Playground/Gamelogic, "turn_finished")
	
	emit_signal("game_over")



