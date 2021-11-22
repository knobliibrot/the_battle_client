extends Control

class_name SearchScreen

func set_status(status: String) -> void:
	$Content/StatusBox/Label.text = status

func get_username() -> String:
	return $Content/UsernameBox/Input.text

func display_status_box() -> void:
	$Content/UsernameBox.visible = false
	$Content/StatusBox.visible = true

func vanish() -> void:
	self.visible = false
