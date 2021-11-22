extends MarginContainer

signal done

func _on_Button_pressed():
	emit_signal("done")
