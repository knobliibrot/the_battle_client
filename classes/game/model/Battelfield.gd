extends Node

class_name Battlefield

signal castle_choosen
signal target_selected
signal troop_selected

const SCENE_MAP: Dictionary = { 
	FieldType.GRASS : "res://classes/game/model/fields/GrassField.tscn",
	FieldType.FOREST : "res://classes/game/model/fields/ForestField.tscn",
	FieldType.MOUNTAIN : "res://classes/game/model/fields/MountainField.tscn",
	FieldType.VILLAGE : "res://classes/game/model/fields/VillageField.tscn",
	FieldType.CASTLE : "res://classes/game/model/fields/CastleField.tscn",
	FieldType.EMPTY : "res://classes/game/model/fields/EmptyField.tscn"
}

# Every Field which get initialzed exists already. So you can find it with the position
func initalize_field(position: Vector2, field_type: int) -> Field:
	var old_field : Field = get_field(position)
	old_field.field_position = position
	return initalize_given_field(old_field, field_type)

# Loads a new Scene and copies the old data into it.
# It also connects the signals from the Fields
func initalize_given_field(old_field: Field, field_type: int) -> Field:
	var new_field: Field = load(SCENE_MAP[field_type]).instance()
	if field_type == FieldType.EMPTY:
		new_field.set_disabled(true)
			
	new_field.copy_data(old_field)
	new_field.field_type = field_type
	var _err = new_field.connect("castle_choosen", self, "_on_Field_castle_choosen")
	_err = new_field.connect("target_selected", self, "_on_Field_target_selected")
	_err = new_field.connect("troop_selected", self, "_on_Field_troop_selected")
	old_field.replace_by(new_field,false)
	return new_field

# Removes the Field from the given position
func delete_child(position: Vector2) -> void:
	remove_child(get_field(position))

# Returns the Field at the given position
func get_field(position: Vector2) -> Field:
	return get_node(str(position.x) + "-" + str(position.y)) as Field

func _on_Field_castle_choosen(position :Vector2) -> void:
	emit_signal("castle_choosen", position)

func _on_Field_target_selected(position :Vector2) -> void:
	emit_signal("target_selected", position)
	
func _on_Field_troop_selected(position :Vector2) -> void:
	emit_signal("troop_selected", position)

