extends "res://classes/scenes/ScreenScene.gd"


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
		yield($Playground/Gamelogic, "turn_finished")
		$Playground/Gamelogic.start_turn(false)
		yield($Playground/Gamelogic, "turn_finished")



