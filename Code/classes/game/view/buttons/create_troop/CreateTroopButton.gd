extends MarginContainer

class_name CreateTroopButton

signal create_troop

export(int) var troop_type

func _on_TextureButton_pressed():
	emit_signal("create_troop", troop_type)
