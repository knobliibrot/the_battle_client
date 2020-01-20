extends TextureButton

class_name Field

signal castle_choosen
signal troop_selected
signal target_selected
signal selection_released

export(Vector2) var field_position: Vector2
export(int) var field_type: int #Enum.FieldType
var field_state: int
var stationed_troop: Troop
var connections: Dictionary = {}

var dijk_distance: int
var dijk_previous: Field
var dijk_visited: bool

func cut_connections() -> void:
	for connection_type in self.connections:
		self.connections[connection_type].delete_connection(FieldConnection.PAIRS[connection_type] )

func force_troop_move(is_player1: bool, troop: Troop) -> bool:
	#TODO: Replace with BFS
	var forced: bool = false
	remove_child(self.stationed_troop)
	if self.stationed_troop != null:		
		if is_player1:
			if connections.has(FieldConnectionTypeEnum.LEFT_UP) && connections[FieldConnectionTypeEnum.LEFT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT) && connections[FieldConnectionTypeEnum.LEFT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_DOWN) && connections[FieldConnectionTypeEnum.LEFT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_UP) && connections[FieldConnectionTypeEnum.RIGHT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT) && connections[FieldConnectionTypeEnum.RIGHT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_DOWN) && connections[FieldConnectionTypeEnum.RIGHT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_UP) && connections[FieldConnectionTypeEnum.LEFT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT) && connections[FieldConnectionTypeEnum.LEFT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_DOWN) && connections[FieldConnectionTypeEnum.LEFT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_UP) && connections[FieldConnectionTypeEnum.RIGHT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT) && connections[FieldConnectionTypeEnum.RIGHT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_DOWN) && connections[FieldConnectionTypeEnum.RIGHT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			else:
				forced = false
		else:
			if connections.has(FieldConnectionTypeEnum.RIGHT_UP) && connections[FieldConnectionTypeEnum.RIGHT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT) && connections[FieldConnectionTypeEnum.RIGHT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_DOWN) && connections[FieldConnectionTypeEnum.RIGHT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_UP) && connections[FieldConnectionTypeEnum.LEFT_UP].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT) && connections[FieldConnectionTypeEnum.LEFT].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_DOWN) && connections[FieldConnectionTypeEnum.LEFT_DOWN].check_and_set_troop(self.stationed_troop, is_player1):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_UP) && connections[FieldConnectionTypeEnum.RIGHT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT) && connections[FieldConnectionTypeEnum.RIGHT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.RIGHT_DOWN) && connections[FieldConnectionTypeEnum.RIGHT_DOWN].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_UP) && connections[FieldConnectionTypeEnum.LEFT_UP].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT) && connections[FieldConnectionTypeEnum.LEFT].force_troop_move(is_player1, self.stationed_troop):
				forced = true
			elif connections.has(FieldConnectionTypeEnum.LEFT_DOWN) && connections[FieldConnectionTypeEnum.LEFT_DOWN].force_troop_move(is_player1, self.stationed_troop):
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

func check_and_set_troop(troop: Troop, is_player1: bool) -> bool:
	if stationed_troop == null:
		set_troop(troop, is_player1)
		return true
	else:
		return false
		
func set_troop(troop: Troop, is_player1: bool) -> void:
	self.stationed_troop = troop
	add_child(troop)
	if is_player1:
		self.add_to_group("troops_stationed_player1")
	else:
		self.add_to_group("troops_stationed_player2")

func get_field_position() -> Vector2:
	return self.field_position
	
func set_field_position(position: Vector2):
	self.field_position = position

func set_rect(rect: Rect2):
	rect_position = rect.position
	rect_size = rect.size
	
func create_troop(troop_type: int, is_player1: bool) -> Troop:
	var troop: Troop
	
	if is_player1:		
		troop = load(TroopType.SCENE_BLUE[troop_type]).instance()
		troop.troop_type = troop_type
		troop.is_player1 = is_player1
		self.add_to_group("troops_stationed_player1")
	else:
		troop = load(TroopType.SCENE_RED[troop_type]).instance()
		troop.troop_type = troop_type
		troop.is_player1 = is_player1
		self.add_to_group("troops_stationed_player2")
	if force_troop_move(is_player1, troop):
		return troop
	else:
		return null
	
	
func copy_data(old_node: Node) -> void:
	set_name(old_node.get_name())
	set_rect(old_node.get_rect())
	self.field_position = old_node.field_position
	self.stationed_troop = old_node.stationed_troop
	for connection_type in old_node.connections:
		old_node.connections[connection_type].set_connection(self, FieldConnection.PAIRS[connection_type] )
		self.connections[connection_type] = old_node.connections[connection_type ]
	
	for group  in old_node.get_groups():
		self.add_to_group(group)
		
func set_connection(field: Field , direction: int) -> void:
	connections[direction] = field
	
func delete_connection(direction: int) -> void:
	connections.erase(direction)

func get_field_type() -> int:
	return field_type
	
func set_field_type(field_type: int) -> void:
	self.field_type = field_type
	
func _on_EmptyField_pressed():
	pass

func _on_Field_toggled(button_pressed):
	if button_pressed:
		match self.field_state:
			FieldStateEnum.TROOP_SELECTION:
				if self.stationed_troop != null:
					emit_signal("troop_selected", field_position)
			FieldStateEnum.TARGET_SELECTION:
				emit_signal("target_selected", field_position)
	else:
		emit_signal("selection_released")
