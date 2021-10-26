extends "res://classes/scenes/GameScene.gd"

var user: Player = Player.new()
var opponent: Player = Player.new()
var first_player: bool

var connected: bool = false
var username_selected: bool = false

func _ready():
	$Client.connect("connected", self, "_on_Client_connected")
	$Client.connect("connection_failed", self, "_on_Client_connection_failed")
	$Client.connect("response_received", self, "_on_Client_response_received")
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTING
	$Client.start_connection()
	

func _on_SearchButton_pressed():
	self.user.name = $SearchScreen/Content/UsernameBox/Input.text
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
	pkg[InterfaceKeys.DATA][InterfaceKeys.USER] = self.user
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
	self.opponent.name = pkg[InterfaceKeys.DATA][InterfaceKeys.OPPONENT]
	self.opponent.init(PlayerType.ONLINE, !pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER])
	self.user.init(PlayerType.MANUAL, pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER])
	self.first_player = pkg[InterfaceKeys.DATA][InterfaceKeys.FIRST_PLAYER]
	print("opponent saved")

# TOODO new workflow: first generate like in offline mode the battlefield and then collect from there the field types
func build_battlefield(pkg: Dictionary) -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.GENERATE_BATTLEFIELD
	var new_pkg = Interface.send_battlefield
	$Content/Playground/Gamelogic.generate_battlefield(true)
	new_pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD] = $Content/Playground/Gamelogic.get_field_type_map()
	send_request(ServiceNames.SEND_BATTLEFIELD, new_pkg)
	$Content/Playground/Gamelogic.initialize_game(self.user, self.opponent)
	print("battlefield generated")

# new basic idea use the old generate battlefield and make an option in with or without given field types
func send_battlefield(pkg: Dictionary) -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.INITIALIZING_GAME
	$Content/Playground/Gamelogic.initialize_battlefield(pkg[InterfaceKeys.DATA][InterfaceKeys.BATTLEFIELD])
	$Content/Playground/Gamelogic.initialize_game(self.user, self.opponent)
	print("battlefield saved")

func start_game(pkg: Dictionary) -> void:
	$SearchScreen.visible = false
	$Content/Playground/Gamelogic.start_initial_mode(self.first_player)
	print("game started")
