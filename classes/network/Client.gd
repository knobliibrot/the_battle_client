extends Node

class_name Client

# The URL we will connect to
export var websocket_url = "127.0.0.1:9080"

# Our WebSocketClient instance
var _client = WebSocketClient.new()

func _ready():
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

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
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).put_packet("Test packet".to_utf8())

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var json_string: String = _client.get_peer(1).get_packet().get_string_from_utf8()
	var error: String = validate_json(json_string)
	if not error:
		print("valid")
		process_request(parse_json(json_string))
#		if typeof(json_string) == TYPE_DICTIONARY:
#			process_request(parse_json(json_string))
#		else:
#			print("unexpected results")
#			print(json_string)
	else:
		prints("invalid", error)
	
	

func process_request(packet: Dictionary) -> void:
	match packet.get("id"):
		"hello_world":
			print(packet.get("data")[0])


