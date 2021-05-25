extends Node

const FIELD_NAME: Dictionary = {
	FieldType.CASTLE : "Castle",
	FieldType.GRASS : "Grass",
	FieldType.MOUNTAIN : "Mountain",
	FieldType.VILLAGE : "Village",
	FieldType.FOREST : "Forest"
}
const CONNECTION_PAIRS: Dictionary = {
	FieldConnectionType.LEFT : FieldConnectionType.RIGHT,
	FieldConnectionType.RIGHT : FieldConnectionType.LEFT,
	FieldConnectionType.LEFT_DOWN : FieldConnectionType.RIGHT_UP,
	FieldConnectionType.LEFT_UP : FieldConnectionType.RIGHT_DOWN,
	FieldConnectionType.RIGHT_DOWN : FieldConnectionType.LEFT_UP,
	FieldConnectionType.RIGHT_UP : FieldConnectionType.LEFT_DOWN
}

const CONNECTION_ORDER_PLAYER1: Array = [
	FieldConnectionType.LEFT_UP,
	FieldConnectionType.LEFT,
	FieldConnectionType.LEFT_DOWN,
	FieldConnectionType.RIGHT_DOWN,
	FieldConnectionType.RIGHT,
	FieldConnectionType.RIGHT_UP
]

const CONNECTION_ORDER_PLAYER2: Array = [
	FieldConnectionType.RIGHT_UP,
	FieldConnectionType.RIGHT,
	FieldConnectionType.RIGHT_DOWN,
	FieldConnectionType.LEFT_DOWN,
	FieldConnectionType.LEFT,
	FieldConnectionType.LEFT_UP,
]

const SPEED: Dictionary = {
	FieldType.CASTLE : 5,
	FieldType.GRASS : 2,
	FieldType.MOUNTAIN : 10,
	FieldType.VILLAGE : 3,
	FieldType.FOREST : 3
}
