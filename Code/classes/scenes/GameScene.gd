extends "res://classes/scenes/ScreenScene.gd"


func _ready():
	var battlefield_map: Array = $Gamelogic.generate_battelfield()
	$Playground/Battelfield.render_battlefield(battlefield_map)
	$Playground.choose_castel(true)
