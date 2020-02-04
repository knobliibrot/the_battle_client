extends TextureButton

class_name Field

signal castle_choosen
signal troop_selected
signal target_selected
signal selection_released

var field_position: Vector2
var field_type: int 
var field_state: int
var stationed_troop: Troop
var connections: Dictionary = {}

var dijk_distance: int
var dijk_previous: Field
var dijk_visited: bool

# Removes all connections from and to this field
func cut_connections() -> void:
	for connection_type in self.connections:
		self.connections[connection_type].delete_connection(FieldSettings.connection_pairs[connection_type])

# Deletes the connection with the given direction from this field
func delete_connection(direction: int) -> void:
	connections.erase(direction)

# Remove stationed troop from field
func remove_stationed_troop() -> void:
	remove_child(stationed_troop)
	stationed_troop = null
	if is_in_group(Group.TROOPS_1):
		remove_from_group(Group.TROOPS_1)
	else:
		remove_from_group(Group.TROOPS_2)

# Initializes a red or blue troop and positiones it on the battlefield
func create_troop(troop_type: int, is_player1: bool) -> Troop:
	var troop: Troop	
	if is_player1:
		troop = load(TroopParameters.SCENE_BLUE[troop_type]).instance()
	else:
		troop = load(TroopParameters.SCENE_RED[troop_type]).instance()		
	troop.troop_type = troop_type
	troop.is_player1 = is_player1
	troop.set_start_healthpoints(TroopSettings.start_health[troop_type])
	self.add_to_group(Group.stationed_troop(is_player1))
	
	if force_troop_move(is_player1, troop):
		return troop
	else:
		return null

# TODO
func force_troop_move(is_player1: bool, troop: Troop) -> bool:
	#TODO: Replace with BFS
	var forced: bool = false
	remove_child(self.stationed_troop)
	if self.stationed_troop != null:		
		if is_player1:
			if connections.has(FieldConnectionType.LEFT_UP) && connections[FieldConnectionType.LEFT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.LEFT) && connections[FieldConnectionType.LEFT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_DOWN) && connections[FieldConnectionType.LEFT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_UP) && connections[FieldConnectionType.RIGHT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT) && connections[FieldConnectionType.RIGHT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_DOWN) && connections[FieldConnectionType.RIGHT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_UP) && connections[FieldConnectionType.LEFT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.LEFT) && connections[FieldConnectionType.LEFT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_DOWN) && connections[FieldConnectionType.LEFT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_UP) && connections[FieldConnectionType.RIGHT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT) && connections[FieldConnectionType.RIGHT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_DOWN) && connections[FieldConnectionType.RIGHT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			else:
				forced = false
		else:
			if connections.has(FieldConnectionType.RIGHT_UP) && connections[FieldConnectionType.RIGHT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT) && connections[FieldConnectionType.RIGHT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_DOWN) && connections[FieldConnectionType.RIGHT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_UP) && connections[FieldConnectionType.LEFT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.LEFT) && connections[FieldConnectionType.LEFT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_DOWN) && connections[FieldConnectionType.LEFT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_UP) && connections[FieldConnectionType.RIGHT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT) && connections[FieldConnectionType.RIGHT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.RIGHT_DOWN) && connections[FieldConnectionType.RIGHT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_UP) && connections[FieldConnectionType.LEFT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.LEFT) && connections[FieldConnectionType.LEFT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionType.LEFT_DOWN) && connections[FieldConnectionType.LEFT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			else:
				forced = false
		if forced:
			set_troop(troop, is_player1)
		else:
			add_child(self.stationed_troop)
	else:
		set_troop(troop, is_player1)
		forced = true
	return forced

# TODO
func check_and_set_troop(troop: Troop, is_player1: bool) -> bool:
	if stationed_troop == null:
		set_troop(troop, is_player1)
		return true
	else:
		return false

# Sets the troop to the field and adds the regarding group to it
func set_troop(troop: Troop, is_player1: bool) -> void:
	self.stationed_troop = troop
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
func _on_Field_toggled(button_pressed: bool) -> void:
	if button_pressed:
		match self.field_state:
			FieldState.TROOP_SELECTION:
				if self.stationed_troop != null:
					emit_signal("troop_selected", field_position)
			FieldState.TARGET_SELECTION:
				emit_signal("target_selected", field_position)
	else:
		emit_signal("selection_released")

# Set position and size
func set_rect(rect: Rect2) -> void:
	self.rect_position = rect.position
	self.rect_size = rect.size

# Sets the connection in the given direction to the given field
func set_connection(field: Field , direction: int) -> void:
	connections[direction] = field