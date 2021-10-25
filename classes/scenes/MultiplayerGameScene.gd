extends "res://classes/scenes/GameScene.gd"

var client = Client.new()
var username: String

func _ready():
	client.connect("connected", self, "_on_Client_connected")
	client.connect("connection_failed", self, "_on_Client_connection_failed")
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTING
	client.start_connection()
	

func _on_SearchButton_pressed():
	self.username = $SearchScreen/Content/UsernameBox/Input.text
	$SearchScreen/Content/UsernameBox.visible = false
	$SearchScreen/Content/StatusBox.visible = true
	

func _on_Client_connected() -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTED

func _on_Client_connection_failed() -> void:
	$SearchScreen/Content/StatusBox/Label.text = SearchOpponentState.CONNECTION_FAILED
