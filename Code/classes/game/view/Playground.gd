extends Node

signal set_castle

const FieldTypeEnum = preload("res://classes/enums/FieldTypeEnum.gd")

const MESSAGE_CONTAINER = preload("res://classes/game/view/boxes/MessageContainer.tscn")
const CASTLE_SCENE = preload("res://classes/game/view/fields/CastleFieldScene.tscn")

func choose_castel(is_player1: bool) -> Vector2:
	var castle_fields: Array
	if is_player1:
		castle_fields = get_tree().get_nodes_in_group("castle_field_1")
	else:
		castle_fields = get_tree().get_nodes_in_group("castle_field_2")
		
	for field in castle_fields:
		field.set_disabled(false)
	
	
	show_message("Place your Castle!", 2)
	$Top/TopBar/TimeBox.start_timer(10)
	
	var position: Vector2 = yield(self, "set_castle")
	if position.x == 1 && position.y == 1:
		if is_player1:
			position.x = 20
		else:
			position.x = 0
	
	for field_node in castle_fields:
		if field_node.field.position == position:
			var game_node = CASTLE_SCENE.instance()
			game_node.field = field_node.field
			game_node.field.set_field_type(FieldTypeEnum.CASTLE)
			game_node.copy_data(field_node)
			field_node.replace_by(game_node,true)
		else:
			$Battelfield/BattelfieldMap.remove_child(field_node)
			# TODO: delete field
		
	
	
	return position
	
func show_message(messsage: String, seconds: float):
	add_child(MESSAGE_CONTAINER.instance())
	$MessageContainer/MarginContainer/Label.text = messsage
	yield(get_tree().create_timer(2.0), "timeout")
	remove_child($MessageContainer)
	
func _on_Battelfield_castle_choosen(position: Vector2):
	$Top/TopBar/TimeBox.stop_timer()
	emit_signal("set_castle", position)

func _on_TimeBox_timeout():
	_on_Battelfield_castle_choosen(Vector2(1, 1))
