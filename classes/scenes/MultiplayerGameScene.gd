extends "res://classes/scenes/GameScene.gd"

var user: Player = Player.new()
var opponent: Player = Player.new()
var is_first_player: bool
var round_timer: int = 0

var connected: bool = false
var username_selected: bool = false
var game_over: bool = false
var close_multiplayer: bool = false

func _ready():
	get_gamelogic().is_multiplayer = true
	get_playground().change_close_to_give_up_button()
	get_search_screen().set_status(SearchOpponentState.CONNECTING)
	get_client().start_connection()

func _on_SearchScreen_stop_opponent_search() -> void:
	self.user.player_name = get_search_screen().get_username()
	get_search_screen().display_status_box()
	self.username_selected = true
	if self.connected:
		send_search_opponent_request()

func _on_Client_connected() -> void:
	get_search_screen().set_status(SearchOpponentState.CONNECTED)
	self.connected = true
	if username_selected:
		send_search_opponent_request()

func send_search_opponent_request() -> void:
	var pkg: Dictionary = Interface.search_opponent
	pkg[InterfaceKeys.DATA][InterfaceKeys.USER] = self.user.player_name
	self.send_request(ServiceNames.SEARCH_OPPONENT, pkg)
	get_search_screen().set_status(SearchOpponentState.SEARCH_OPPONENT)

func _on_Client_connection_failed() -> void:
	get_search_screen().set_status(SearchOpponentState.CONNECTION_FAILED)

func send_request(service_id: String, pkg: Dictionary) -> void:
	if ServiceNames.VALID_REQUEST_IDS.has(service_id):
		get_client().send_request(pkg)

func _on_Client_response_received(pkg: Dictionary) -> void:
	if ServiceNames.VALID_RESPONSE_IDS.has(pkg[InterfaceKeys.ID]):
		print("call: " + pkg[InterfaceKeys.ID])
		self.call(pkg[InterfaceKeys.ID], pkg)
	else:
		print("Response id doesn't exist " + pkg[InterfaceKeys.ID])

func _on_Client_connection_closed() -> void:
	if self.close_multiplayer:
		emit_signal("ready_to_close")
	else:
		if !self.game_over:
			print("Something with the server went wrong")
			get_search_screen().vanish()
			get_playground().show_game_over_overlay(false, true)

func _on_SearchScreen_ready_to_close() -> void:
	if self.connected:
		self.close_multiplayer = true
		get_client().close_connection("Multiplayer closed")
	else:
		emit_signal("ready_to_close")

func opponent_found(pkg: Dictionary) -> void:
	get_search_screen().set_status(SearchOpponentState.OPPONENT_FOUND)
	self.opponent.player_name = pkg[InterfaceKeys.DATA][InterfaceKeys.OPPONENT]
	self.opponent.init(PlayerType.ONLINE)
	self.user.init(PlayerType.MANUAL)
	self.is_first_player = pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER]
	print("opponent saved")

func build_battlefield(pkg: Dictionary) -> void:
	get_search_screen().set_status(SearchOpponentState.GENERATE_BATTLEFIELD)
	var new_pkg = Interface.send_battlefield
	get_gamelogic().generate_battlefield(true)
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD] = get_gamelogic().get_field_type_map()
	send_request(ServiceNames.SEND_BATTLEFIELD, new_pkg)
	get_gamelogic().initialize_online_game(self.user, self.opponent, true)
	print("battlefield generated")

func send_battlefield(pkg: Dictionary) -> void:
	get_search_screen().set_status(SearchOpponentState.INITIALIZING_GAME)
	get_gamelogic().initialize_battlefield(pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD])
	get_gamelogic().initialize_online_game(self.opponent, self.user, false)
	print("battlefield saved")

func start_game(pkg: Dictionary) -> void:
	get_search_screen().vanish()
	get_gamelogic().start_initial_mode(self.is_first_player)
	print("game started")

func _on_Gamelogic_initial_done(selected_troops: Array, castle_position: Vector2) -> void:
	var new_pkg = Interface.initial_turn_finished
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.SELECTED_TROOPS] = selected_troops
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.X] = int(castle_position.x)
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.Y] = int(castle_position.y)
	send_request(ServiceNames.INITIAL_TURN_FINISHED, new_pkg)
	get_playground().wait_for_opponent_initial_round_finished(self.opponent)
	print("selected troops and caste position sent")

func initial_turn_finished(pkg: Dictionary) -> void:
	self.opponent.selected_troops = pkg[InterfaceKeys.DATA][InterfaceKeys.SELECTED_TROOPS]
	var x: float = float(pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.X])
	var y: float = float(pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.Y])
	self.opponent.castle_position = Vector2(x, y)
	get_gamelogic().set_actual_player(!self.is_first_player)
	get_gamelogic().set_castle(self.opponent.castle_position)
	get_gamelogic().start_game_mode()
	get_gamelogic().start_turn(true, self.round_timer)
	if self.is_first_player:
		send_turn_started()
	print("game mode started")

func send_turn_started() -> void:
	var new_pkg = Interface.turn_started
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.STARTING_TIME] = get_playground().get_actual_time_started()
	send_request(ServiceNames.TURN_STARTED, new_pkg)

func turn_started(pkg: Dictionary) -> void:
	get_playground().set_timer(pkg[InterfaceKeys.DATA][InterfaceKeys.STARTING_TIME])

func _on_Gamelogic_turn_finished() -> void:
	var new_pkg = Interface.turn_finished
	send_request(ServiceNames.TURN_FINISHED, new_pkg)
	
	print("Round " + str(self.round_timer) + ", " + self.user.player_name + "; finished")
	if !self.is_first_player:
		self.round_timer += 1
	get_gamelogic().start_turn(!self.is_first_player, self.round_timer)
	send_turn_started()

func turn_finished(pkg: Dictionary) -> void:
	get_gamelogic().game_turn_done()
	print("Round " + str(self.round_timer) + ", " + self.opponent.player_name + "; finished")
	if self.is_first_player:
		self.round_timer += 1
	get_gamelogic().start_turn(self.is_first_player, self.round_timer)

func _on_Gamelogic_adding_to_queue(troop_type: int) -> void:
	var new_pkg = Interface.adding_to_queue
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.TROOP_TYPE] = troop_type
	send_request(ServiceNames.ADDING_TO_QUEUE, new_pkg)
	print("troop added to queue")

func adding_to_queue(pkg: Dictionary) -> void:
	get_gamelogic().add_troop_to_queue(pkg[InterfaceKeys.DATA][InterfaceKeys.TROOP_TYPE])
	print("troop added to queue")

func _on_Gamelogic_removing_from_queue(queue_pos: int) -> void:
	var new_pkg = Interface.removing_from_queue
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.QUEUE_POS] = queue_pos
	send_request(ServiceNames.REMOVING_FROM_QUEUE, new_pkg)
	print("troop removed from queue")

func removing_from_queue(pkg: Dictionary) -> void:
	get_gamelogic().remove_troop_from_queue(pkg[InterfaceKeys.DATA][InterfaceKeys.QUEUE_POS])
	print("troop removed from queue")

func _on_Gamelogic_moving_troop(from: Vector2, to: Vector2):
	var new_pkg = Interface.moving_troop
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.FROM][InterfaceKeys.X] = from.x
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.FROM][InterfaceKeys.Y] = from.y
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.TO][InterfaceKeys.X] = to.x
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.TO][InterfaceKeys.Y] = to.y
	send_request(ServiceNames.MOVING_TROOP, new_pkg)
	print("movement made")

func moving_troop(pkg: Dictionary) -> void:
	var from_y: int = pkg[InterfaceKeys.DATA][InterfaceKeys.FROM][InterfaceKeys.Y]
	var from_x: int = pkg[InterfaceKeys.DATA][InterfaceKeys.FROM][InterfaceKeys.X]
	get_gamelogic().selected_field = get_gamelogic().battlefield_map[from_y][from_x]
	get_gamelogic().calculate_distance_to_troop_and_change_status_of_fields(Vector2(from_x,from_y))
	var to_y: int = pkg[InterfaceKeys.DATA][InterfaceKeys.TO][InterfaceKeys.Y]
	var to_x: int = pkg[InterfaceKeys.DATA][InterfaceKeys.TO][InterfaceKeys.X]
	get_gamelogic().move_troop(Vector2(to_x, to_y))
	print("movement made")

func _on_Gamelogic_give_up():
	self.game_over = true
	var new_pkg = Interface.give_up
	send_request(ServiceNames.GIVE_UP, new_pkg)
	print("gave up")

func give_up(pkg: Dictionary) -> void:
	self.game_over = true
	get_gamelogic().opponent_gave_up()
	print("opoonent gave up")

func _on_Gamelogic_game_over(player: Player):
	self.game_over = true
	var new_pkg = Interface.game_over
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.PLAYER] = player.player_name
	send_request(ServiceNames.GAME_OVER, new_pkg)
	print("game over")

func game_over(pkg: Dictionary) -> void:
	self.game_over = true
	get_gamelogic().game_over()
	print("opoonent game over")

func _on_Gamelogic_game_finished():
	emit_signal("ready_to_close")

func get_client() -> Client:
	return get_node("Client") as Client

func get_search_screen() -> Node:
	return get_node("SearchScreen")

func get_playground() -> Playground:
	return get_node("Content/Playground") as Playground

func get_gamelogic() -> Gamelogic:
	return get_node("Content/Playground/Gamelogic") as Gamelogic
