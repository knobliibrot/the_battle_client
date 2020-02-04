extends Node

class_name FieldMapPerDistance

var distance: int
# Is a dictionary for performance
var dict: Dictionary = {}

func pop_first() -> Field:
	var item = dict.values()[0]
	dict.erase(item.field_position)
	return item

func erase(position: Vector2) -> void:
	dict.erase(position)