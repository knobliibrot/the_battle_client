extends Node

# This class controls everything what happens in the playground and emits signal to the GameScene
class_name Gamelogic

signal castle_set
signal turn_finished

const SCENE_FIELDSET: PackedScene = preload("res://classes/tools/FieldPositionSet.tscn")

var battlefield_map: Array 
var selected_field: Field

var player1: Player
var player2: Player
var act_player: Player
var act_opponent: Player
var is_player1: bool

var game_over: bool = false

# Initialize the players with the given player types
func initialize_game(player1_type: int, player2_type: int) -> void: 
	self.player1 = Player.new()
	self.player1.init(player1_type, true)
	self.player1.player_name= "Player 1"
	self.player2 = Player.new()
	self.player2.init(player2_type, false)
	self.player2.player_name= "Player 2"

# Generates the battlefield randomly
func generate_battelfield() -> void:
	self.battlefield_map = $BattlefieldGenerator.generate_battlefield()

# Starts the castle choosing process for the given player
func start_castel_choosing(is_player1: bool) -> void:
	set_actual_players(is_player1)
	
	if self.act_player.player_type == PlayerType.MANUAL:
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		get_playground().activate_castle_mode(is_player1)
		get_playground().start_timer_with_message("Place your Castle " + self.act_player.player_name + "!", GameSettings.round_time, "set_castle_timer_finished")	

func _on_Battlefield_castle_choosen(position: Vector2) -> void:
	set_castle(position)

func _on_TimeBox_set_castle_timer_finished() -> void:
	if self.is_player1:
		set_castle(Vector2(GameSettings.battlefield_width - 1, GameSettings.castle_start_height))
	else:
		set_castle(Vector2(0, GameSettings.castle_start_height))

# Sets the castle at the given position. 
# If it's called through a timout it will take the CASTLE_START_HEIGHT
func set_castle(position: Vector2) -> void:
	var castle_fields: Array = []
	# Get the castle fields
	castle_fields = get_tree().get_nodes_in_group(Group.castle_field(self.is_player1))
	
	for empty_field in castle_fields:
		if position == empty_field.field_position:
			var new_field: Field = get_battlefield().initalize_given_field(empty_field, FieldType.CASTLE) 
			self.act_player.castle_position = position
			battlefield_map[empty_field.field_position.y][empty_field.field_position.x] = new_field
		else:
			empty_field.cut_connections()
			get_battlefield().remove_child(empty_field)
			battlefield_map[empty_field.field_position.y][empty_field.field_position.x] = null
	
	get_playground().stop_timer()
	emit_signal("castle_set")

# Starts a turn of the actual player
func start_turn(is_player1: bool) -> void:
	set_actual_players(is_player1)
	if self.act_player.player_type == PlayerType.MANUAL:
		pay_and_trainingday()
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		get_playground().activate_turn_mode(is_player1, act_player)
		get_playground().start_timer_with_message("Your turn " + act_player.player_name + "!", GameSettings.round_time, "turn_finished")	

# Adds the income to the player's gold and creates a troop if there is one ready on the queue
func pay_and_trainingday() -> void:
	self.act_player.gold += self.act_player.income
	
	var new_troop_type: int = self.act_player.get_new_troop()
	if new_troop_type >= 0:
		self.act_player.salary += TroopSettings.salary[new_troop_type]
		self.act_player.income = GameSettings.basic_income - self.act_player.salary
		var castle_pos: Vector2 = self.act_player.castle_position
		var troop: Troop = battlefield_map[castle_pos.y][castle_pos.x].create_troop(new_troop_type, self.is_player1)
		if troop == null :
			get_parent().show_message("WTF the Battelfield is full !!!",3)
		else:
			self.act_player.troops.append((troop))
	
	for troop in self.act_player.troops:
		troop.movement_left = TroopSettings.fpr[troop.troop_type]

func _on_QueueBar_remove_from_queue(position: int) -> void:
	self.act_player.remove_from_queue(position)
	get_parent().update_gui_with_player(self.player1, self.player2, self.is_player1)

func _on_TroopButton_create_troop(troop_type: int) -> void:
	add_troop_to_queue(troop_type)

# Adds troop to queue if there is space and enaugh money 
func add_troop_to_queue(troop_type: int) -> void:
	if self.act_player.gold >= TroopSettings.price[troop_type]:
		if !self.act_player.add_troop_to_queue(troop_type):
			get_playground().show_message("The queue is full!", 1)
		else:
			self.act_player.gold -= TroopSettings.price[troop_type]
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
	else:
		get_playground().show_message("You don't have enaugh money!", 1)

func _on_Battlefield_troop_selected(pos: Vector2) -> void:
	self.selected_field = battlefield_map[pos.y][pos.x]
	calculate_distance_to_troop_and_change_status_of_fields(pos)

# Run a djikstra algorithm over all fields to check with are in the distance of the selected troop
# And change the fields to Disability regarding on the distance
func calculate_distance_to_troop_and_change_status_of_fields(troop_pos: Vector2) -> void:	
	var field_set = SCENE_FIELDSET.instance()
	var max_travel_distance = battlefield_map[troop_pos.y][troop_pos.x].stationed_troop.movement_left
	
	# Add all fields to the set with max distance
	for field in get_playground().get_tree().get_nodes_in_group("fields"):
		field.dijk_distance = ApplicationSettings.MAX_INT
		field.dijk_previous = null
		field.dijk_visited = false		
		field_set.add_new(ApplicationSettings.MAX_INT, field)
	
	# Set troop position to distance 0
	field_set.change_existing(0, battlefield_map[troop_pos.y][troop_pos.x])
	
	while !field_set.is_empty():
		# Get field with lowest distance
		var act_field : Field = field_set.pop_first()
		act_field.dijk_visited = true
		# Depending on the distance set it's status
		if max_travel_distance >= act_field.dijk_distance:
			act_field.set_disabled(false)
			act_field.field_state = FieldState.TARGET_SELECTION
			act_field.set_pressed(false)
		else:
			act_field.set_disabled(true)
			act_field.set_pressed(false)
		# Calculate the distance to the neighbours as long there is not an opponent's troop on the field
		if act_field.stationed_troop == null or act_field.stationed_troop.is_player1 == self.is_player1:
			for key in act_field.connections:
				if !act_field.connections[key].dijk_visited:
					var new_dist: int = act_field.dijk_distance + FieldSettings.speed[act_field.connections[key].field_type]
					if new_dist < act_field.connections[key].dijk_distance:
						act_field.connections[key].dijk_previous = act_field
						field_set.change_existing(new_dist, act_field.connections[key])

func _on_Battlefield_selection_released() -> void:
	self.selected_field = null
	get_playground().activate_turn_mode(is_player1, act_player)

func _on_Battlefield_target_selected(position: Vector2):
	var target: Field = battlefield_map[position.y][position.x]
	var movement_type: int
	if target.stationed_troop != null:
		movement_type = fight(self.selected_field.stationed_troop, target.stationed_troop)
	elif target.field_position == self.act_opponent.castle_position:
		movement_type = attack_castle(self.selected_field.stationed_troop, target)
	else:
		movement_type = MovementType.NO_FIGHT
	show_movement(self.selected_field.stationed_troop, target.stationed_troop, target, movement_type)
	
	self.selected_field = null
	if self.game_over:
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		game_over()
	else:
		get_playground().activate_turn_mode(is_player1, act_player)
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)

# Calculates the fight and returns the resulting movement type
func fight(attacker: Troop, defender: Troop) -> int:
	if self.act_player.troops.has(defender):
		return MovementType.FRIEND
	else:
		# Attacker attacks Defender
		var field_bonus: float = get_field_bonus_att(attacker, defender)
		var troop_bonus: float = get_troop_bonus(attacker, defender.troop_type)
		defender.set_healthpoints(defender.get_healthpoints() - (TroopSettings.att_dmg[attacker.troop_type] * field_bonus * troop_bonus))
		
		if defender.get_healthpoints() > 0:
			# Defender attacks Attacker
			field_bonus = get_field_bonus_def(attacker, defender)
			troop_bonus = get_troop_bonus(defender, attacker.troop_type)
			attacker.set_healthpoints(attacker.get_healthpoints() - (TroopSettings.def_dmg[defender.troop_type] * field_bonus * troop_bonus))
			
			if attacker.get_healthpoints() > 0:
				return MovementType.NOBODY_DIE
			else:
				return MovementType.ATT_DIE
		else:
			return MovementType.DEF_DIE

# Get troop bonus from the attacker against the defender
func get_troop_bonus(attacker: Troop, defender_troop_type: int) -> int:
	var troop_bonus: float = 1
	for troop_type in TroopSettings.special_dmg[attacker.troop_type]:
			if troop_type == defender_troop_type:
				troop_bonus = TroopSettings.special_dmg[attacker.troop_type][troop_type]
				break
	return int(troop_bonus)

# Get field bonus for the defender
func get_field_bonus_def(attacker: Troop, defender: Troop) -> int:
	var field_bonus: float = 1
	for troop_type in FieldSettings.def_dmg[defender.get_parent().field_type]:
				if troop_type == defender.troop_type:
					field_bonus = FieldSettings.def_dmg[defender.get_parent().field_type][troop_type]
					break
	return int(field_bonus)

# Get field bouns for the attacker
func get_field_bonus_att(attacker: Troop, defender: Troop) -> int:
	var field_bonus: float = 1
	for troop_type in FieldSettings.att_dmg[defender.get_parent().field_type]:
		if troop_type == attacker.troop_type:
			field_bonus = FieldSettings.att_dmg[defender.get_parent().field_type][troop_type]
			break
	return int(field_bonus)

# Calculate castle attack, set game over flag and return movement type "NOBODY_DIE"
func attack_castle(attacker: Troop, castle: Field) -> int:
	var troop_bonus: float = get_troop_bonus(attacker, TroopType.CASTLE)
	
	self.act_opponent.castle_health = int(self.act_opponent.castle_health - TroopSettings.att_dmg[attacker.troop_type] * troop_bonus)
	if self.act_opponent.castle_health < 1:
		self.game_over = true
	
	return MovementType.NOBODY_DIE

# TODO
func show_movement(attacker: Troop, defender: Troop, target_field: Field, movement_type: int) -> void:
	var final_target: Field = target_field
	if MovementType.ATT_DIE == movement_type:
		act_player.remove_troop(attacker)
	elif MovementType.FRIEND == movement_type:
		pass
	else:
		if MovementType.DEF_DIE == movement_type:
			if is_player1:
				player2.remove_troop(defender)
			else:
				player1.remove_troop(defender)
		if MovementType.NOBODY_DIE == movement_type or (MovementType.DEF_DIE == movement_type and target_field.field_type == FieldType.CASTLE):
			final_target = target_field.dijk_previous
			while final_target.stationed_troop != null and final_target != attacker.get_parent():
				final_target = final_target.dijk_previous
			attacker.movement_left  -= target_field.dijk_distance + (target_field.dijk_distance - final_target.dijk_distance * 2)
		
		move_troop(attacker, final_target)

# TODO
func move_troop(troop: Troop, target: Field) -> void:
	var group_name: String
	if is_player1:
		group_name = "troops_stationed_player1"
	else:
		group_name = "troops_stationed_player2"
	troop.get_parent().stationed_troop = null		
	troop.get_parent().remove_from_group(group_name)	
	troop.get_parent().remove_child(troop)
	troop.movement_left = troop.movement_left - target.dijk_distance
	target.add_child(troop)
	target.stationed_troop = troop
	target.add_to_group(group_name)

# Stops Round, show Game Over and finish the game
func game_over() -> void:
	get_playground().disable_all()
	get_playground().stop_timer()
	get_playground().show_message("Game Over " + self.act_opponent.player_name, 5)
	
	yield(get_tree().create_timer(4), "timeout")
	
	emit_signal("turn_finished", true)

func _on_TimeBox_turn_finished() -> void:
	emit_signal("turn_finished", false)

# Sets the actual player and opponent for this round
func set_actual_players(is_player1: bool) -> void:
	self.is_player1 = is_player1
	if is_player1:
		self.act_player = self.player1
		self.act_opponent = self.player2
	else:
		self.act_player = self.player2
		self.act_opponent = self.player1

# Returns the Playground / Parent
func get_playground() -> Playground:
	return self.get_parent() as Playground

# Returns the Battlefield
func get_battlefield() -> Battlefield:
	return get_playground().get_node("Battlefield") as Battlefield
