extends Node

const MESSAGE_CONTAINER = preload("res://classes/game/view/boxes/MessageContainer.tscn")
const CASTLE_SCENE = preload("res://classes/game/view/fields/CastleField.tscn")


func update_gui_with_player(player: Player) -> void:
	$UI/Top/TopBar/GoldBox/NinePatchRect/Label.text = str(player.gold)
	$UI/Top/TopBar/IncomeBox/NinePatchRect/Label.text =  str(player.income)
	$UI/Top/TopBar/SalaryBox/NinePatchRect/Label.text =  str(player.salary)

func start_timer_with_message(message: String, seconds: float, finish_signal: String) -> void:
	show_message(message, GameParameters.MESSAGE_SHOW_TIME)
	$UI/Top/TopBar/TimeBox.start_timer(seconds, finish_signal)
	
func show_message(message: String, seconds: float):
	var msg_ontainer = MESSAGE_CONTAINER.instance()
	add_child(msg_ontainer)
	msg_ontainer.get_node("MarginContainer/Label").text = message
	yield(get_tree().create_timer(seconds), "timeout")
	remove_child(msg_ontainer)
	
func stop_timer():
	$UI/Top/TopBar/TimeBox.stop_timer()
	
func activate_castle_mode(is_player1: bool) -> void:
	var castle_fields: Array
	if is_player1:
		castle_fields = get_tree().get_nodes_in_group("castle_field_1")
	else:
		castle_fields = get_tree().get_nodes_in_group("castle_field_2")
		
	for field in castle_fields:
		field.set_disabled(false)
	
func activate_turn_mode(is_player1: bool, player: Player) -> void:
	for button in get_tree().get_nodes_in_group("create_troop_button"):
		button.set_disabled(false)
	

func _on_CreateTroopButton_create_troop(troop_type: TroopTypeEnum):
	 pass
