extends Node

class_name Field

export(Vector2) var position: Vector2
export(int) var field_type: int #Enum.FieldType
var neighbour_up_left: Field
var neighbour_up_right: Field
var neighbour_left: Field
var neighbour_right: Field
var neighbour_dwon_left: Field
var neighbour_down_right: Field

func set_position(x: int, y: int):
	position = Vector2(x, y)

func get_field_type() -> int:
	return field_type
	
func set_field_type(field_type: int) -> void:
	self.field_type = field_type