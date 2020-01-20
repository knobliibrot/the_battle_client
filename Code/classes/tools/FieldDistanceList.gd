extends Node

var distance: int
var dict: Dictionary = {}

func pop_first():
	var item = dict.values()[0]
	dict.erase(item.field_position)
	return item
	
func pop(position: Vector2):
	var item = dict[position]
	dict.erase(item.field_position)
	return item