extends TextureButton

class_name Field

signal castle_choosen
signal troop_selected
signal target_selected

const FATORY_SCENE = "res://classes/game/model/Factory.tscn"

var field_position: Vector2
var field_type: int 
var field_state: int
var stationed_troop: Troop
var connections: Dictionary = {}
var factory: Factory

var dijk_distance: int
var dijk_previous: Field
var dijk_direction: int
var dijk_visited: bool
var att_dmg: int
var def_dmg: int
var bfs_visited: bool

func _ready() -> void:
	self.set_toggle_mode(true)

# Returns an array with the connetion types from the start field to the current
func get_dijk_path() -> Array:
	var path: Array = []
	if(self.dijk_previous != null):
		var act_field: Field = self.dijk_previous
		while act_field.dijk_previous != null:
			path.insert(0, act_field.dijk_direction)
			act_field = act_field.dijk_previous
	return path

# Removes all connections from and to this field
func cut_connections() -> void:
	for connection_type in self.connections:
		self.connections[connection_type].delete_connection(FieldSettings.connection_pairs[connection_type])

# Deletes the connection with the given direction from this field
func delete_connection(direction: int) -> void:
	var _err = connections.erase(direction)

# Remove stationed troop from field
func remove_stationed_troop(troop: Troop) -> void:
	remove_child(troop)
	troop.parent_field.stationed_troop = null
	if troop.parent_field.is_in_group(Group.TROOPS_1):
		troop.parent_field.remove_from_group(Group.TROOPS_1)
	else:
		troop.parent_field.remove_from_group(Group.TROOPS_2)

# Initializes a red or blue troop and positiones it on the battlefield
func create_troop(troop_type: int, is_player1: bool, battlefield_map: Array) -> Troop:
	var troop: Troop	
	if is_player1:
		troop = load(TroopParameters.SCENE_BLUE[troop_type]).instance()
	else:
		troop = load(TroopParameters.SCENE_RED[troop_type]).instance()
	troop.troop_type = troop_type
	troop.is_player1 = is_player1
	troop.set_start_healthpoints(TroopSettings.start_health[troop_type])
	troop.parent_field = self
	self.add_to_group(Group.stationed_troop(is_player1))
	
	if force_troop_move(is_player1, troop, battlefield_map):
		return troop
	else:
		return null

# Move the troop in the castle when a new one spawns in the castle
func force_troop_move(is_player1: bool, troop: Troop, battlefield_map: Array) -> bool:
	# Reset the visited value of all fields
	for column in battlefield_map:
		for field in column:
			if field != null:
				field.bfs_visited = false
	
	var replaced: bool = false
	var queue: Array = []
	
	# BFS
	queue.append(self)
	while !queue.empty():
		var act_field: Field = queue.pop_front()
		if self.check_and_set_troop(act_field, troop, is_player1):
			replaced = true
			break
		act_field.bfs_visited = true
		
		# Iterate trhough the connections in the given order
		for neighbours_key in FieldSettings.get_connection_order(is_player1):
			if act_field.connections.has(neighbours_key) && !act_field.connections[neighbours_key].bfs_visited:
				queue.append(act_field.connections[neighbours_key])
	
	return replaced

# Checks if there is no troop on the field. If yes the given troop is added to the given field
func check_and_set_troop(field: Field, troop: Troop, is_player1: bool) -> bool:
	if field.stationed_troop == null:
		field.set_troop(troop, is_player1)
		return true
	else:
		return false

# Sets the troop to the field and adds the regarding group to it
func set_troop(troop: Troop, is_player1: bool) -> void:
	self.stationed_troop = troop
	troop.parent_field = self
	add_child(troop)
	self.add_to_group(Group.stationed_troop(is_player1))

# Copy all data in here from given field
func copy_data(old_node: Field) -> void:
	set_name(old_node.get_name())
	set_rect(old_node.get_rect())
	self.field_position = old_node.field_position
	self.stationed_troop = old_node.stationed_troop
	for connection_type in old_node.connections:
		old_node.connections[connection_type].set_connection(self, FieldSettings.connection_pairs[connection_type])
		self.connections[connection_type] = old_node.connections[connection_type ]
	
	for group  in old_node.get_groups():
		self.add_to_group(group)

# This function is just used for EmptyFields
func _on_EmptyField_pressed() -> void:
	pass

# Emits signal depending on the field state
func _on_Field_pressed() -> void:
	match self.field_state:
		FieldState.TROOP_SELECTION:
			if self.stationed_troop != null:
				emit_signal("troop_selected", field_position)
		FieldState.TARGET_SELECTION:
			emit_signal("target_selected", field_position)

# Set position and size
func set_rect(rect: Rect2) -> void:
	self.rect_position = rect.position
	self.rect_size = rect.size

# Sets the connection in the given direction to the given field
func set_connection(field: Field , direction: int) -> void:
	connections[direction] = field

# Creates a new factory on the field
func add_factory() -> void:
	self.factory = load(FATORY_SCENE).instance()
	self.add_child(self.factory )

# Changes the blur and informations if a field get activated
func set_disabled(value: bool) -> void:
	self.disabled = value
	if !value:
		if field_state == FieldState.TARGET_SELECTION and dijk_distance > 0:
			$Node2D/MarginContainer/VBoxContainer/Distance/Label.text = str(dijk_distance)
			$Node2D/MarginContainer/VBoxContainer/Distance.visible = true
			if self.stationed_troop != null:
				$Node2D/Blur.visible = true
				$Node2D/MarginContainer/VBoxContainer/Att_Dmg/Label.text = str(att_dmg)
				$Node2D/MarginContainer/VBoxContainer/Def_Dmg/Label.text = str(def_dmg)
				$Node2D/MarginContainer/VBoxContainer/Att_Dmg.visible = true
				$Node2D/MarginContainer/VBoxContainer/Def_Dmg.visible = true
	else:
		$Node2D/MarginContainer/VBoxContainer/Distance.visible = false
		if self.stationed_troop != null:
			$Node2D/Blur.visible = false
			$Node2D/MarginContainer/VBoxContainer/Att_Dmg.visible = false
			$Node2D/MarginContainer/VBoxContainer/Def_Dmg.visible = false
