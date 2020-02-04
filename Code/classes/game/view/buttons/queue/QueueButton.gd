extends MarginContainer

class_name QueueButton

signal remove_from_queue

var position: int

func _ready() -> void:
	self.add_to_group(Group.QUEUE_BUTTON)

func _on_Button_pressed() -> void:
	emit_signal("remove_from_queue", position)
