extends Node

signal castle_choosen


const SCENE_MAP = { 
FieldTypeEnum.GRASS : "res://classes/game/view/fields/GrassField.tscn",
FieldTypeEnum.FOREST : "res://classes/game/view/fields/ForestField.tscn",
FieldTypeEnum.MOUNTAIN : "res://classes/game/view/fields/MountainField.tscn",
FieldTypeEnum.VILLAGE : "res://classes/game/view/fields/VillageField.tscn",
FieldTypeEnum.CASTLE : "res://classes/game/view/fields/CastleField.tscn",
FieldTypeEnum.EMPTY : "res://classes/game/view/fields/EmptyField.tscn"}



func initalize_field(position: Vector2, field_type: int) -> Field:	
	var old_node : Field = get_field(position)
	old_node.set_field_position(position)
	return initalize_given_field(old_node, field_type)

func initalize_given_field(old_node: Field, field_type: int) -> Field:
	var new_node: Field = load(SCENE_MAP[field_type]).instance()	
	if field_type == FieldTypeEnum.EMPTY:
		new_node.set_disabled(true)
			
	new_node.copy_data(old_node)
	new_node.set_field_position(old_node.get_field_position())
	new_node.field_type = field_type
	new_node.connect("castle_choosen", self, "_on_Field_castle_choosen")
	old_node.replace_by(new_node,false)
	return new_node
	
func delete_child(position: Vector2) -> void:
	remove_child(get_field(position))
	
func get_field(position: Vector2) -> Node:
	return get_node(str(position.x) + "-" + str(position.y)) 
				
				
func _on_Field_castle_choosen(position :Vector2) -> void:
	emit_signal("castle_choosen", position)


func _on_ArcherButton_create_troop():
	pass # Replace with function body.
