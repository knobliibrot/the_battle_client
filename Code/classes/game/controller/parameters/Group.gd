extends Node

class_name Group

const TROOPS_1: String = "troops_stationed_player1"
const TROOPS_2: String = "troops_stationed_player2"

const CASTEL_FIELDS_1: String = "castle_field_1"
const CASTEL_FIELDS_2: String = "castle_field_2"
const FIELDS: String = "fields"

const CREATE_TROOP_BUTTON: String = "create_troop_button"
const QUEUE_BUTTON: String = "qeueue_button"

static func stationed_troop(is_player1: bool) -> String:
	if is_player1:
		return TROOPS_1
	else:
		return TROOPS_2

static func castle_field(is_player1: bool) -> String:
	if is_player1:
		return CASTEL_FIELDS_1
	else:
		return CASTEL_FIELDS_2