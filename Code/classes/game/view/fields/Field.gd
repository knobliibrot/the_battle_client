extends TextureButton

class_name Field

signal castle_choosen

export(Vector2) var field_position: Vector2
export(int) var field_type: int #Enum.FieldType
var neighbour_up_left: Field
var neighbour_up_right: Field
var neighbour_left: Field
var neighbour_right: Field
var neighbour_dwon_left: Field
var neighbour_down_right: Field


func get_field_position() -> Vector2:
	return self.field_position
	
func set_field_position(position: Vector2):
	self.field_position = position

func set_rect(rect: Rect2):
	rect_position = rect.position
	rect_size = rect.size
	
func copy_data(old_node: Node) -> void:
	set_name(old_node.get_name())
	set_rect(old_node.get_rect())
	for group  in old_node.get_groups():
		self.add_to_group(group)

func get_field_type() -> int:
	return field_type
	
func set_field_type(field_type: int) -> void:
	self.field_type = field_type
	
func _on_EmptyField_pressed():
	pass