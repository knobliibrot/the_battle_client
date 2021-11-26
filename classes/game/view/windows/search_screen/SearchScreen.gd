extends Control

class_name SearchScreen

signal stop_opponent_search
signal ready_to_close

# Change Status based on SearchOpponentState
func set_status(status: String) -> void:
	$Content/StatusBox/Label.text = status

# Return username from input
func get_username() -> String:
	return $Content/UsernameBox/Input.text

# Make Usernamebox invisible and Statusbox visible
func display_status_box() -> void:
	$Content/UsernameBox.visible = false
	$Content/StatusBox.visible = true

# Make it self invisible
func vanish() -> void:
	self.visible = false

func _on_SearchButton_pressed() -> void:
	emit_signal("stop_opponent_search")


func _on_StopSearchButton_pressed():
	emit_signal("ready_to_close")
