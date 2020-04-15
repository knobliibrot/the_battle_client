extends Node

# This class controls everything what happens in the playground and emits signal to the GameScene
class_name Gamelogic

signal castle_set
signal turn_finished
signal play_finished

const FIELD_DISTANCE_SET_SCENE: PackedScene = preload("res://classes/tools/FieldDistanceSet.tscn")

var battlefield_map: Array 
var selected_field: Field

var player1: Player
var player2: Player
var act_player: Player
var act_opponent: Player
var is_player1: bool

var factory_capture_mode_enabled: bool

var game_over: bool
var att_animation_finished: bool = false
var def_animation_finished: bool = false
var play_running: bool = false

# Initialize the players with the given player types
func initialize_game(player1_type: int, player2_type: int) -> void: 
	self.player1 = Player.new()
	self.player1.init(player1_type, true)
	self.player1.player_name= "Player 1"
	self.player2 = Player.new()
	self.player2.init(player2_type, false)
	self.player2.player_name= "Player 2"
	self.factory_capture_mode_enabled = false
	self.game_over = false

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
func start_turn(is_player1: bool, round_timer: int) -> void:
	set_actual_players(is_player1)
	if round_timer == GameSettings.factory_activation_time && !is_player1:
		self.factory_capture_mode_enabled = true
		activate_factories(self.player2)
		activate_factories(self.player1)
	if self.act_player.player_type == PlayerType.MANUAL:
		pay_and_trainingday()
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		get_playground().activate_turn_mode(is_player1)
		get_playground().start_timer_with_message("Your turn " + act_player.player_name + "!", GameSettings.round_time, "turn_finished")

func activate_factories(player: Player) -> void:
	for troop in player.troops:
		if (troop.parent_field.factory != null):
			capture_factory(troop.parent_field, player)

# Adds the income to the player's gold and creates a troop if there is one ready on the queue
func pay_and_trainingday() -> void:
	
	self.act_player.gold += self.act_player.income - self.act_player.salary
	
	var new_troops: Array = self.act_player.get_new_troops()
	for new_troop_type in new_troops:
		self.act_player.salary += TroopSettings.salary[new_troop_type]
		var castle_pos: Vector2 = self.act_player.castle_position
		var troop: Troop = battlefield_map[castle_pos.y][castle_pos.x].create_troop(new_troop_type, self.is_player1)
		if troop == null :
			get_playground().show_message("WTF the Battelfield is full !!!",3)
		else:
			self.act_player.troops.append((troop))
	
	for troop in self.act_player.troops:
		troop.movement_left = TroopSettings.fpr[troop.troop_type]
		troop.attack_done = false

func _on_QueueBar_remove_from_queue(position: int) -> void:
	self.act_player.remove_from_queue(position)
	get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)

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
	var field_set = FIELD_DISTANCE_SET_SCENE.instance()
	var stationed_troop: Troop = battlefield_map[troop_pos.y][troop_pos.x].stationed_troop
	var max_travel_distance: int = stationed_troop.movement_left
	var attack_done: bool = stationed_troop.attack_done
	var first_move: bool = max_travel_distance == TroopSettings.fpr[stationed_troop.troop_type]
	
	# Add all fields to the set with max distance
	for field in get_playground().get_tree().get_nodes_in_group(Group.FIELDS):
		field.dijk_distance = ApplicationSettings.MAX_INT
		field.dijk_previous = null
		field.dijk_visited = false
		field_set.add_new(ApplicationSettings.MAX_INT, field)
	
	# Set troop position to distance 0
	field_set.change_existing(0, battlefield_map[troop_pos.y][troop_pos.x])
	
	var act_field : Field = field_set.pop_first_field()
	while act_field != null:
		act_field.dijk_visited = true
		# Depending on the distance set it's status
		if ((
			(max_travel_distance >= act_field.dijk_distance or
				(act_field.dijk_previous != null and 
				act_field.dijk_previous.dijk_distance == 0 and 
				first_move)
			) and 
			!act_player.troops.has(act_field.stationed_troop) and 
			!(act_field.stationed_troop != null and attack_done)
		) or
		act_field == battlefield_map[troop_pos.y][troop_pos.x]):
			act_field.field_state = FieldState.TARGET_SELECTION
			act_field.set_disabled(false)
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
						set_dijk_values(act_field, key, stationed_troop)
						field_set.change_existing(new_dist, act_field.connections[key])
		# Get field with lowest distance
		act_field = field_set.pop_first_field()

# sets the values needed for the dijkstra and the possible damage for the field in the given direction
func set_dijk_values(act_field: Field, direction: int, stationed_troop: Troop) -> void:
	var target_field: Field = act_field.connections[direction]
	target_field.dijk_direction = direction
	target_field.dijk_previous = act_field
	# distance is changes in FieldMapPerDistance.change_existing()
	if target_field.stationed_troop != null:
		target_field.att_dmg = get_attacker_damage(stationed_troop, target_field.stationed_troop)
		target_field.def_dmg = get_defender_damage(stationed_troop, target_field.stationed_troop)

# Procedure when a target is selected
func _on_Battlefield_target_selected(position: Vector2):
	self.play_running = true
	var target: Field = battlefield_map[position.y][position.x]
	var troop: Troop = self.selected_field.stationed_troop
	troop.movement_left = troop.movement_left - target.dijk_distance
	# Calculate possible fight
	var movement_type: int
	if target.stationed_troop != null:
		movement_type = fight(troop, target.stationed_troop)
	elif target.field_position == self.act_opponent.castle_position:
		movement_type = attack_castle(troop)
	else:
		movement_type = MovementType.NO_FIGHT
	# Animate the movement and fight
	if target.dijk_distance > 0:
		yield(show_movement(troop, target.stationed_troop, target, movement_type), "completed")
	# Cleanup
	self.selected_field = null
	if self.game_over:
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		game_over()
	else:
		var state = get_playground().activate_turn_mode(is_player1)
		state.resume()
		get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		state = get_playground().update_gui_with_player(self.player1, self.player2, self.is_player1)
		state.resume()
	self.play_running = false
	emit_signal("play_finished")

# Calculates the fight and returns the resulting movement type
func fight(attacker: Troop, defender: Troop) -> int:
	if self.act_player.troops.has(defender):
		return MovementType.FRIEND
	else:
		attacker.attack_done = true
		defender.set_healthpoints(defender.get_healthpoints() - get_attacker_damage(attacker, defender))
		
		if defender.get_healthpoints() > 0:
			attacker.set_healthpoints(attacker.get_healthpoints() - get_defender_damage(attacker, defender))
			
			if attacker.get_healthpoints() > 0:
				return MovementType.NOBODY_DIE
			else:
				return MovementType.ATT_DIE
		else:
			return MovementType.DEF_DIE

# Returns the damage which the attacker makes against this defender
func get_attacker_damage(attacker: Troop, defender: Troop) -> int:
	var field_bonus: float = get_field_bonus_att(attacker, defender)
	var troop_bonus: float = get_troop_bonus(attacker, defender.troop_type)
	return int(float(TroopSettings.att_dmg[attacker.troop_type]) * field_bonus * troop_bonus)

# Returns the damage which the defender makes against this attacker
func get_defender_damage(attacker: Troop, defender: Troop) -> int:
	var field_bonus = get_field_bonus_def(defender)
	var troop_bonus = get_troop_bonus(defender, attacker.troop_type)
	return int(float(TroopSettings.def_dmg[defender.troop_type]) * field_bonus * troop_bonus)

# Get troop bonus from the attacker against the defender
func get_troop_bonus(attacker: Troop, defender_troop_type: int) -> float:
	var troop_bonus: float = 1
	for troop_type in TroopSettings.special_dmg[attacker.troop_type]:
			if troop_type == defender_troop_type:
				troop_bonus = TroopSettings.special_dmg[attacker.troop_type][troop_type]
				break
	return float(troop_bonus)

# Get field bonus for the defender
func get_field_bonus_def(defender: Troop) -> float:
	var field_bonus: float = 1
	for troop_type in FieldSettings.def_dmg[defender.parent_field.field_type]:
				if troop_type == defender.troop_type:
					field_bonus = FieldSettings.def_dmg[defender.parent_field.field_type][troop_type]
					break
	return float(field_bonus)

# Get field bouns for the attacker
func get_field_bonus_att(attacker: Troop, defender: Troop) -> float:
	var field_bonus: float = 1
	for troop_type in FieldSettings.att_dmg[defender.parent_field.field_type]:
		if troop_type == attacker.troop_type:
			field_bonus = FieldSettings.att_dmg[defender.parent_field.field_type][troop_type]
			break
	return float(field_bonus)

# Calculate castle attack, set game over flag and return movement type "NOBODY_DIE"
func attack_castle(attacker: Troop) -> int:
	if attacker.attack_done:
		attacker.attack_done = true
	var troop_bonus: float = get_troop_bonus(attacker, TroopType.CASTLE)
	self.act_opponent.castle_health = int(float(self.act_opponent.castle_health) - float(TroopSettings.att_dmg[attacker.troop_type]) * troop_bonus)
	if self.act_opponent.castle_health < 1:
		self.game_over = true
	
	return MovementType.NOBODY_DIE

# Moves the attacker to the field before the target
# Animates a fight if there is one
# Makes the last move dependend on the fight outcome
func show_movement(attacker: Troop, defender: Troop, target_field: Field, movement_type: int) -> void:
	get_playground().disable_battlefield()
	var start_field: Field = attacker.parent_field
	var final_target: Field = target_field
	var _err = attacker.connect("animation_finished", self, "_on_Attacker_animation_finished")
	if defender != null:
		_err = defender.connect("animation_finished", self, "_on_Defender_animation_finished")
	
	# Move to field before
	var path: Array = target_field.get_dijk_path()
	if path.size() > 0:
		attacker.move(path)
		yield(attacker, "move_finished")
		move_troop_temp(attacker, target_field.dijk_previous)
	# Fight Animation 
	path = [final_target.dijk_direction]
	if MovementType.FRIEND != movement_type and MovementType.NO_FIGHT != movement_type:
		var direction: int = target_field.dijk_direction
		if defender == null:
			# Fight against the castle
			attacker.start_attack_animation(direction)
			yield(attacker, "animation_finished")
			attacker.attack_animation(direction)
			yield(attacker, "animation_finished")
			attacker.end_attack_animation(direction)
			yield(attacker, "animation_finished")
		else:
			# Start Fight
			reset_ani_finished()
			attacker.start_attack_animation(direction)
			defender.start_defend_animation(direction)
			yield(attacker, "animation_finished")
			if !self.def_animation_finished:
				yield(defender, "animation_finished")
			# Attacker attacks
			attacker.attack_animation(direction)
			yield(attacker, "animation_finished")
			defender.update_helathpoints()
			if MovementType.DEF_DIE == movement_type:
				# Defender dies
				defender.die_animation()
				yield(defender, "animation_finished")
				self.act_opponent.remove_troop(defender)
				attacker.win_attack_animation(direction)
				yield(attacker, "animation_finished")
				path = []
			else:
				# Defender attacks
				defender.defend_animation(direction)
				yield(defender, "animation_finished")
				attacker.update_helathpoints()
				if MovementType.ATT_DIE == movement_type:
					# Attacker dies
					attacker.die_animation()
					yield(attacker, "animation_finished")
					self.act_player.remove_troop(attacker)
					defender.end_defend_animation(direction)
					yield(defender, "animation_finished")
				else:
					# End Fight
					reset_ani_finished()
					attacker.end_attack_animation(direction)
					defender.end_defend_animation(direction)
					yield(attacker, "animation_finished")
					if !self.def_animation_finished:
						yield(defender, "animation_finished")
		# Find position to go back after attack
		if MovementType.NOBODY_DIE == movement_type or (MovementType.DEF_DIE == movement_type and target_field.field_type == FieldType.CASTLE):
			final_target = target_field.dijk_previous
			path = []
			while final_target.stationed_troop != null and final_target != start_field:
				path.append(FieldParameters.CONNECTION_PAIRS[final_target.dijk_direction])
				final_target = final_target.dijk_previous
	# Make last move
	if MovementType.ATT_DIE != movement_type:
		if path.size() > 0:
			attacker.move(path)
			yield(attacker, "move_finished")
		
		var state = move_troop(attacker, start_field, final_target)
		state.resume()
		attacker.disconnect("animation_finished", self, "_on_Attacker_animation_finished")
	# Cleanup
	if defender != null:
		defender.disconnect("animation_finished", self, "_on_Defender_animation_finished")

# Moves the troop to the given target on the gui but without any logic update
func move_troop_temp(troop: Troop, target: Field) -> void:
	troop.get_parent().remove_child(troop)
	troop.set_position(Vector2(0,0))
	target.add_child(troop)

# Moves the troop to the final position and makes the logic updates
func move_troop(troop: Troop, start: Field, target: Field) -> void:
	start.stationed_troop = null
	start.remove_from_group(Group.stationed_troop(self.is_player1))
	troop.get_parent().remove_child(troop)
	troop.set_position(Vector2(0,0))
	troop.parent_field = target
	target.add_child(troop)
	target.stationed_troop = troop
	target.add_to_group(Group.stationed_troop(self.is_player1))
	if target.factory != null && factory_capture_mode_enabled:
		capture_factory(target, self.act_player)
	yield()

# The actual player takes the factory on the given field if it's not owned before the given user is used
func capture_factory(field: Field, player: Player) -> void:
	if field.factory.is_owned:
		if field.factory.is_owner_player1 != is_player1:
			act_opponent.factories.erase(field.factory)
			act_opponent.income = act_opponent.income - GameSettings.income_per_factory
			act_player.factories.append(field.factory)
			act_player.income += GameSettings.income_per_factory
	else:
		field.factory.is_owned = true
		player.factories.append(field.factory)
		player.income += GameSettings.income_per_factory
	field.factory.set_is_owner_player1(player == self.player1)

# Resetes the global animation finished variables
func reset_ani_finished() -> void:
	self.att_animation_finished = false
	self.def_animation_finished = false

func _on_Attacker_animation_finished() -> void:
	self.att_animation_finished = true

func _on_Defender_animation_finished() -> void:
	self.def_animation_finished = true

# Stops Round, show Game Over and finish the game
func game_over() -> void:
	get_playground().disable_all()
	get_playground().stop_timer()
	get_playground().show_message("Game Over " + self.act_opponent.player_name, 5)
	
	yield(get_tree().create_timer(4), "timeout")
	
	emit_signal("turn_finished", true)

func _on_DoneBox_done() -> void:
	self.turn_done()

func _on_TimeBox_turn_finished() -> void:
	self.turn_done()

# Stops the timer, waits until the running play is finished and emits the finsih signal
func turn_done() -> void:
	get_playground().stop_timer()
	if self.play_running:
		yield(self, "play_finished")
	if !self.game_over:
		print("turn finished, player1: " + str(self.is_player1))
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



