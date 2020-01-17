extends TextureButton

class_name FieldScene

signal castle_choosen

var field: Field

func set_rect(rect: Rect2):
	rect_position = rect.position
	rect_size = rect.size
	
func copy_data(old_node: Node) -> void:
	set_name(old_node.get_name())
	set_rect(old_node.get_rect())