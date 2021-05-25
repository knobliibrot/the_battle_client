extends Node

var connection_pairs: Dictionary = FieldParameters.CONNECTION_PAIRS.duplicate()

var connection_order_player1: Array = FieldParameters.CONNECTION_ORDER_PLAYER1.duplicate()

var connection_order_player2: Array = FieldParameters.CONNECTION_ORDER_PLAYER2.duplicate()

func get_connection_order(is_player1) -> Array:
	if is_player1:
		return self.connection_order_player1
	else:
		return self.connection_order_player2

var speed: Dictionary = FieldParameters.SPEED.duplicate()

var field_name: Dictionary = FieldParameters.FIELD_NAME.duplicate()
