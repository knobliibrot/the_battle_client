extends Node


const FieldTypeEnum = preload("res://classes/enums/FieldTypeEnum.gd")

const MESSAGE_CONTAINER = preload("res://classes/game/view/boxes/MessageContainer.tscn")
const CASTLE_SCENE = preload("res://classes/game/view/fields/CastleField.tscn")


func start_timer_with_message(message: String, seconds: float) -> void:
	show_message(message, 3)
	$UI/Top/TopBar/TimeBox.start_timer(seconds, "set_castle_timer_finished")
	
func show_message(message: String, seconds: float):
	var msg_ontainer = MESSAGE_CONTAINER.instance()
	add_child(msg_ontainer)
	msg_ontainer.get_node("MarginContainer/Label").text = message
	yield(get_tree().create_timer(seconds), "timeout")
	remove_child(msg_ontainer)
	
func stop_timer():
	$UI/Top/TopBar/TimeBox.stop_timer()
	
