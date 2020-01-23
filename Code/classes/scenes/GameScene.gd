extends "res://classes/scenes/ScreenScene.gd"

signal game_over

func _ready():
	$Content/Playground/Gamelogic.initialize_game(PlayerTypeEnum.MANUAL, PlayerTypeEnum.MANUAL)
	$Content/Playground/Gamelogic.generate_battelfield()
	
	$Content/Playground/Gamelogic.choose_castel(true)
	yield($Content/Playground/Gamelogic, "castle_set")
	$Content/Playground/Gamelogic.choose_castel(false)
	yield($Content/Playground/Gamelogic, "castle_set")
	
	var game_finished: bool = false
	while(!game_finished):
		$Content/Playground/Gamelogic.start_turn(true)
		game_finished = yield($Content/Playground/Gamelogic, "turn_finished")
		if !game_finished:
			$Content/Playground/Gamelogic.start_turn(false)
			game_finished = yield($Content/Playground/Gamelogic, "turn_finished")
	
	emit_signal("game_over")



