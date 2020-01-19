extends MarginContainer

class_name QueueButton

signal remove_from_queue

var position: int

func _on_Button_pressed():
	emit_signal("remove_from_queue", position)
