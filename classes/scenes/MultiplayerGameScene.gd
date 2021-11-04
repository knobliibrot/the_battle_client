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
		print("Response id doesn't exist" + pkg[InterfaceKeys.ID])

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
	$Content/Playground/Gamelogic.initialize_game(self.user, self.opponent)
	print("battlefield generated")

func send_battlefield(pkg: Dictionary) -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.INITIALIZING_GAME
	$Content/Playground/Gamelogic.initialize_battlefield(pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD])
	if self.is_first_player:
		$Content/Playground/Gamelogic.initialize_game(self.user, self.opponent)
	else:
		$Content/Playground/Gamelogic.initialize_game(self.opponent, self.user)
	print("battlefield saved")

func start_game(pkg: Dictionary) -> void:
	$SearchScreen.visible = false
	$Content/Playground/Gamelogic.start_initial_mode(self.is_first_player)
	print("game started")

func _on_Gamelogic_initial_done( selected_troops: Array, castle_position: Vector2) -> void:
	self.initial_turn_finished = true
	var new_pkg = Interface.initial_turn_finished
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.SELECTED_TROOPS] = selected_troops
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.X] = int(castle_position.x)
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.Y] = int(castle_position.y)
	send_request(ServiceNames.INITIAL_TURN_FINISHED, new_pkg)
	$Content/Playground/Gamelogic.set_castle(opponent.castle_position, true)
	$Content/Playground.wait_for_opponent_initial_round_finished(!is_first_player, opponent)
	print("selected troops and caste position sent")
	if self.opponent_initial_turn_finished:
		start_game_mode()

func initial_turn_finished(pkg: Dictionary) -> void:
	self.opponent_initial_turn_finished = true
	opponent.selected_troops = pkg[InterfaceKeys.DATA][InterfaceKeys.SELECTED_TROOPS]
	var x: float = float(pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.X])
	var y: float = float(pkg[InterfaceKeys.DATA][InterfaceKeys.CASTEL_POSITION][InterfaceKeys.Y])
	opponent.castle_position = Vector2(x, y)
	if self.initial_turn_finished:
		start_game_mode()
 
func start_game_mode() -> void:
	$Content/Playground/Gamelogic.start_game_mode()
	$Content/Playground/Gamelogic.start_turn(true, self.round_timer)
	print("game mode started")
