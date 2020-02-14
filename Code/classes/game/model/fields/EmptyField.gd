extends Field

func _on_EmptyField_pressed() -> void:
	emit_signal("castle_choosen", self.field_position)

func _on_Field_toggled(button_pressed: bool) -> void:
	pass
