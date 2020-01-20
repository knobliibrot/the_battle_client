extends Field



func _on_EmptyField_pressed():
	emit_signal("castle_choosen", .get_field_position())

func _on_Field_toggled(button_pressed):
	pass