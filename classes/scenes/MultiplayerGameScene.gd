extends "res://classes/scenes/GameScene.gd"

var user: Player = Player.new()
var opponent: Player = Player.new()
var is_first_player: bool
var round_timer: int = 0

var connected: bool = false
var username_selected: bool = false
var initial_turn_finished: bool = false
var opponent_initial_turn_finished: bool = false

func _ready():
	$Client.connect("connected", self, "_on_Client_connected")
	$Client.connect("connection_failed", self, "_on_Client_connection_failed")
	$Client.connect("response_received", self, "_on_Client_response_received")
	$Content/Playground/Gamelogic.is_multiplayer = true
	$Content/Playground.change_close_to_give_up_button()
	# TODO delete direct calls in SearchScreen and Playground keep Controller and View seperated
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTING
	$Client.start_connection()

func _on_SearchButton_pressed():
	self.user.player_name = $SearchScreen/Content/UsernameBox/Input.text
	$SearchScreen/Content/UsernameBox.visible = false
	$SearchScreen/Content/StatusBox.visible = true
	self.username_selected = true
	if connected:
		send_search_opponent_request()
	

func _on_Client_connected() -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTED
	self.connected = true
	if username_selected:
		send_search_opponent_request()

func send_search_opponent_request() -> void:
	var pkg: Dictionary = Interface.search_opponent
	pkg[InterfaceKeys.DATA][InterfaceKeys.USER] = self.user.player_name
	self.send_request(ServiceNames.SEARCH_OPPONENT, pkg)
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.SEARCH_OPPONENT

func _on_Client_connection_failed() -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTION_FAILED

func send_request(service_id: String, pkg: Dictionary) -> void:
	if ServiceNames.VALID_REQUEST_IDS.has(service_id):
		$Client.send_request(pkg)

func _on_Client_response_received(pkg: Dictionary) -> void:
	if ServiceNames.VALID_RESPONSE_IDS.has(pkg[InterfaceKeys.ID]):
		print("call: " + pkg[InterfaceKeys.ID])
		self.call(pkg[InterfaceKeys.ID], pkg)
	else:
		print("Response id doesn't exist " + pkg[InterfaceKeys.ID])

func opponent_found(pkg: Dictionary) -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.OPPONENT_FOUND
	self.opponent.player_name = pkg[InterfaceKeys.DATA][InterfaceKeys.OPPONENT]
	self.opponent.init(PlayerType.ONLINE, !pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER])
	self.user.init(PlayerType.MANUAL, pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER])
	self.is_first_player = pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER]
	print("opponent saved")

func build_battlefield(pkg: Dictionary) -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.GENERATE_BATTLEFIELD
	var new_pkg = Interface.send_battlefield
	$Content/Playground/Gamelogic.generate_battlefield(true)
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD] = $Content/Playground/Gamelogic.get_field_type_map()
	send_request(ServiceNames.SEND_BATTLEFIELD, new_pkg)
	$Content/Playground/Gamelogic.initialize_online_game(self.user, self.opponent, true)
	print("battlefield generated")

func send_battlefield(pkg: Dictionary) -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.INITIALIZING_GAME
	$Content/Playground/Gamelogic.initialize_battlefield(pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD])
	$Content/Playground/Gamelogic.initialize_online_game(self.opponent, self.user, false)
	print("battlefield saved")

func start_game(pkg: Dictionary) -> void:
	$SearchScreen.visible = false
	$Content/Playground/Gamelogic.start_initial_mode(self.is_first_player)
	print("game started")

func _on_Gamelogic_initial_done( selected_troops: Array, castle_position: Vector2) -> void:
	var new_pkg = Interface.initial_turn_finished
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.SELECTED_TROOPS] = selected_troops
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.X] = int(castle_position.x)
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.Y] = int(castle_position.y)
	send_request(ServiceNames.INITIAL_TURN_FINISHED, new_pkg)
	$Content/Playground.wait_for_opponent_initial_round_finished(opponent)
	print("selected troops and caste position sent")

func initial_turn_finished(pkg: Dictionary) -> void:
	opponent.selected_troops = pkg[InterfaceKeys.DATA][InterfaceKeys.SELECTED_TROOPS]
	var x: float = float(pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.X])
	var y: float = float(pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.Y])
	opponent.castle_position = Vector2(x, y)
	$Content/Playground/Gamelogic.set_actual_player(!is_first_player)
	$Content/Playground/Gamelogic.set_castle(opponent.castle_position)
	$Content/Playground/Gamelogic.start_game_mode()
	$Content/Playground/Gamelogic.start_turn(true, self.round_timer)
	if is_first_player:
		send_turn_started()
	print("game mode started")

func send_turn_started() -> void:
	var new_pkg = Interface.turn_started
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.STARTING_TIME] = $Content/Playground/CentredGame/Top/TopBar/TopBar2/TimeBox.actual_time_started
	send_request(ServiceNames.TURN_STARTED, new_pkg)

func turn_started(pkg) -> void:
	$Content/Playground/CentredGame/Top/TopBar/TopBar2/TimeBox.set_timer(pkg[InterfaceKeys.DATA][InterfaceKeys.STARTING_TIME])

func _on_Gamelogic_turn_finished():
	var new_pkg = Interface.turn_finished
	send_request(ServiceNames.TURN_FINISHED, new_pkg)
	
	print("Round " + str(round_timer) + ", " + self.user.player_name + "; finished")
	if !is_first_player:
		self.round_timer += 1
	$Content/Playground/Gamelogic.start_turn(!is_first_player, self.round_timer)
	send_turn_started()

func turn_finished(pkg: Dictionary) -> void:
	$Content/Playground/Gamelogic.game_turn_done()
	print("Round " + str(round_timer) + ", " + self.opponent.player_name + "; finished")
	if is_first_player:
		self.round_timer += 1
	$Content/Playground/Gamelogic.start_turn(is_first_player, self.round_timer)

func _on_Gamelogic_adding_to_queue(troop_type: int):
	var new_pkg = Interface.adding_to_queue
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.TROOP_TYPE] = troop_type
	send_request(ServiceNames.ADDING_TO_QUEUE, new_pkg)
	print("troop added to queue")

func adding_to_queue(pkg: Dictionary) -> void:
	$Content/Playground/Gamelogic.add_troop_to_queue(pkg[InterfaceKeys.DATA][InterfaceKeys.TROOP_TYPE])
	print("troop added to queue")

func _on_Gamelogic_removing_from_queue(queue_pos: int):
	var new_pkg = Interface.removing_from_queue
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.QUEUE_POS] = queue_pos
	send_request(ServiceNames.REMOVING_FROM_QUEUE, new_pkg)
	print("troop removed from queue")

func removing_from_queue(pkg: Dictionary) -> void:
	$Content/Playground/Gamelogic.remove_troop_from_queue(pkg[InterfaceKeys.DATA][InterfaceKeys.QUEUE_POS])
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
	$Content/Playground/Gamelogic.selected_field = $Content/Playground/Gamelogic.battlefield_map[from_y][from_x]
	$Content/Playground/Gamelogic.calculate_distance_to_troop_and_change_status_of_fields(Vector2(from_x,from_y))
	var to_y: int = pkg[InterfaceKeys.DATA][InterfaceKeys.TO][InterfaceKeys.Y]
	var to_x: int = pkg[InterfaceKeys.DATA][InterfaceKeys.TO][InterfaceKeys.X]
	$Content/Playground/Gamelogic.move_troop(Vector2(to_x, to_y))
	print("movement made")

func _on_Gamelogic_give_up():
	var new_pkg = Interface.give_up
	send_request(ServiceNames.GIVE_UP, new_pkg)

func give_up(pkg: Dictionary) -> void:
	$Content/Playground/Gamelogic.opponent_gave_up()

func _on_Gamelogic_game_over(player: Player):
	var new_pkg = Interface.game_over
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.PLAYER] = player.player_name
	send_request(ServiceNames.GAME_OVER, new_pkg)

func game_over(pkg: Dictionary) -> void:
	$Content/Playground/Gamelogic.game_over()

func _on_Gamelogic_game_finished():
	emit_signal("ready_to_close")
