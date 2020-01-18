extends "res://classes/scenes/ScreenScene.gd"

const PlayerTypeEnum = preload("res://classes/enums/PlayerTypeEnum.gd")

func _ready():
	$Playground/Gamelogic.generate_battelfield()
	$Playground/Gamelogic.choose_castel(true, PlayerTypeEnum.MANUAL)
	yield($Playground/Gamelogic, "castle_set")
	print("tssd")
	$Playground/Gamelogic.choose_castel(false, PlayerTypeEnum.MANUAL)



