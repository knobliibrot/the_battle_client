extends Node

class_name Factory

var is_owned: bool = false
var is_owner_player1: bool setget set_is_owner_player1 

func set_is_owner_player1(flag: bool) -> void:
	is_owner_player1 = flag
	if flag:
		$Red.visible = false
		$Blue.visible = true
	else:
		$Red.visible = true
		$Blue.visible = false

