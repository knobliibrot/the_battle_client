extends Node

class_name Client

signal connected
signal connection_failed
signal response_received

# The URL we will connect to
export var websocket_url: String

# Our WebSocketClient instance
var _client: WebSocketClient = WebSocketClient.new()

func _ready():
	load_websocket_client()
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

func load_websocket_client() -> void:
	var url: String
	if GameSettings.is_server_url:
		url = GameParameters.SERVER_URL
	else:
		url = GameParameters.LOCALHOST_URL
	var port: String
	if GameSettings.is_prod_port:
		port = GameParameters.PROD_PORT
	else:
		port = GameParameters.TEST_PORT
	self.websocket_url = url + ":" + port

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()

func start_connection() -> void:
	# Initiate connection to the given URL.
	print("start to connect")
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		emit_signal("connection_failed")		
		set_process(false)
	else:
		print("ok")

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	emit_signal("connected")
	print("Connected with protocol: ", proto)

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var json_string: String = _client.get_peer(1).get_packet().get_string_from_utf8()
	print(json_string)
	var error: String = validate_json(json_string)
	if not error:
		print("valid")
		emit_signal("response_received", (parse_json(json_string)))
#		if typeof(json_string) == TYPE_DICTIONARY:
#			process_request(parse_json(json_string))
#		else:
#			print("unexpected results")
#			print(json_string)
	else:
		prints("invalid", error)

func send_request(pkg: Dictionary) -> void:
	_client.get_peer(1).put_packet(to_json(pkg).to_utf8())


