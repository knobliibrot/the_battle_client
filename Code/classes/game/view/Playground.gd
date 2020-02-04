extends Node

class_name Playground

const MESSAGE_CONTAINER = preload("res://classes/game/view/boxes/MessageContainer.tscn")
const CASTLE_SCENE = preload("res://classes/game/model/fields/CastleField.tscn")

# Updates the info-, castlehealth- and queue boxes
func update_gui_with_player(player1: Player, player2: Player, is_player1: bool) -> void:
	var act_player
	if is_player1:
		act_player = player1
	else:
		act_player = player2
	$UI/Top/TopBar/GoldBox/NinePatchRect/Label.text = str(act_player.gold)
	$UI/Top/TopBar/IncomeBox/NinePatchRect/Label.text =  str(act_player.income)
	$UI/Top/TopBar/SalaryBox/NinePatchRect/Label.text =  str(act_player.salary)
	$UI/Bottom/BottomBar/QueueBar.clear_queue()
	for i in range(act_player.queue.size()):
		$UI/Bottom/BottomBar/QueueBar.add(act_player.queue[i], i, act_player.progress_actual_troop_in_queue)
	$UI/Bottom/BottomBar/HealthBarBlue/Background/HealthBoxBlue.update_health(player1.castle_health)
	$UI/Bottom/BottomBar/HealthBarRed/Background/HealthBoxRed.update_health(player2.castle_health)

# Set fields for selecting the castle for the given player
func activate_castle_mode(is_player1: bool) -> void:
	var castle_fields: Array
	castle_fields = get_tree().get_nodes_in_group(Group.castle_field(is_player1))
	
	for field in castle_fields:
		field.set_disabled(false)

# Activates create buttons and make all fields with own troops on int selectable
func activate_turn_mode(is_player1: bool, player: Player) -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		button.set_disabled(false)
	
	for field in get_tree().get_nodes_in_group(Group.FIELDS):
		field.set_disabled(true)

	for field in get_tree().get_nodes_in_group(Group.stationed_troop(is_player1)):
		if field.stationed_troop.movement_left > 0:
			field.set_disabled(false)
			field.pressed = false
			field.field_state = FieldState.TROOP_SELECTION

# Disables everything 
func disable_all() -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		button.set_disabled(true)
	
	for field in get_tree().get_nodes_in_group(Group.FIELDS):
		field.set_disabled(true)
	
	for field in get_tree().get_nodes_in_group(Group.QUEUE_BUTTON):
		field.set_disabled(true)

# Add given TroopType to queue
func add_to_queue(player_type: int) -> void:
	$UI/Bottom/BottomBar/QueueBar.add(player_type)

# Starts the Round Timer in the TimeBox  with a message 
# And the signal which should get emitted at the end
func start_timer_with_message(message: String, seconds: float, finish_signal: String) -> void:
	show_message(message, GameSettings.message_show_time)
	$UI/Top/TopBar/TimeBox.start_timer(seconds, finish_signal)

# Shows a message for the given time 
func show_message(message: String, seconds: float) -> void:
	if self.has_node("MessageContainer"):
		self.remove_child(get_node("MessageContainer"))
		
	var msg_container = MESSAGE_CONTAINER.instance()
	add_child(msg_container)
	msg_container.get_node("MarginContainer/Label").text = message
	yield(get_tree().create_timer(seconds), "timeout")
	if has_node("MessageContainer"):
		remove_child(get_node("MessageContainer"))
	
func stop_timer() -> void:
	$UI/Top/TopBar/TimeBox.stop_timer()
	