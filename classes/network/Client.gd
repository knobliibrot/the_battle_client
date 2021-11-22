extends Node

class_name Client

signal connected
signal connection_failed
signal response_received
signal connection_closed

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
	_client.connect("server_close_request", self, "_close_requested")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

# Set Websocket url based on the settings
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


# Call this in _process or _physics_process. Data transfer, and signals
# emission will only happen when calling this function.
func _process(delta):
	_client.poll()


# Initiate connection to the given URL.
func start_connection() -> void:
	print("start to connect")
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		emit_signal("connection_failed")
		set_process(false)
	else:
		print("ok")

func _close_requested(code: int, reason: String) -> void:
	print("Server requested close with Code: %d and Reason: %s" % [code, reason])

# was_clean will tell you if the disconnection was correctly notified
# by the remote peer before closing the socket.
func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	emit_signal("connection_closed")

# This is called on connection, "proto" will be the selected WebSocket
# sub-protocol (which is optional)
func _connected(proto = ""):
	emit_signal("connected")
	print("Connected with protocol: ", proto)

# Convert received data to Dictionary and send signal 
func _on_data():
	var json_string: String = _client.get_peer(1).get_packet().get_string_from_utf8()
	print(json_string)
	var error: String = validate_json(json_string)
	if not error:
		print("valid")
		if typeof(json_string) == TYPE_DICTIONARY:
			emit_signal("response_received", (parse_json(json_string)))
		else:
			print("unexpected results")
			print(json_string)
	else:
		prints("invalid", error)

# Send package as PoolByte array to server
func send_request(pkg: Dictionary) -> void:
	_client.get_peer(1).put_packet(to_json(pkg).to_utf8())

func close_connection(reason: String) -> void:
	_client.disconnect_from_host(1000, reason)
