extends "res://classes/scenes/ScreenScene.gd"


func _on_Gamelogic_battlefield_generated():
	$Playground/Battelfield.render_battlefield($Gamelogic.get_battlefield_map())
