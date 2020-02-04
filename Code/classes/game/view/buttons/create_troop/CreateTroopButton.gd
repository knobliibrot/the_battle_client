extends MarginContainer

class_name CreateTroopButton

signal create_troop

var troop_type: int

func _on_TextureButton_pressed() -> void:
	emit_signal("create_troop", troop_type)
