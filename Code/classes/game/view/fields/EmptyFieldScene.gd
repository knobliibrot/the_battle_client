extends "res://classes/game/view/fields/FieldScene.gd"



func _on_EmptyField_pressed():
	emit_signal("castle_choosen", field.position)
