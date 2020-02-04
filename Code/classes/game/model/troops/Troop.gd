extends MarginContainer

class_name Troop

var troop_type: int
var movement_left: int
var is_player1: bool

# Healthpoints are saved in TextureProgress.value
func get_healthpoints() -> int:
	return $MarginContainer/TextureProgress.value

# Healthpoints are saved in TextureProgress.value
func set_healthpoints(value: int) -> void:
	$MarginContainer/TextureProgress.value = value
	$MarginContainer/TextureProgress/Label.text = str(value) + " / " + str($MarginContainer/TextureProgress.max_value)

# Healthpoints are saved in TextureProgress.value
func set_start_healthpoints(value: int) -> void:
	$MarginContainer/TextureProgress.value = value
	$MarginContainer/TextureProgress.max_value = value
	$MarginContainer/TextureProgress/Label.text = str(value) + " / " + str(value)