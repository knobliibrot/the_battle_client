extends Node

class_name Playground

signal gui_ready
signal game_finished

const MESSAGE_CONTAINER = preload("res://classes/game/view/boxes/MessageContainer.tscn")
const CASTLE_SCENE = preload("res://classes/game/model/fields/CastleField.tscn")
const SETTINGS_SCENE = preload("res://classes/game/controller/settings/SettingsWindow.tscn")

# Updates the info-, castlehealth- and queue boxes
func update_gui_with_player(player1: Player, player2: Player, is_player1: bool) -> void:
	var act_player
	if is_player1:
		act_player = player1
	else:
		act_player = player2
	$CentredGame/Top/TopBar/GoldBox/NinePatchRect/Label.text = str(act_player.gold)
	$CentredGame/Top/TopBar/IncomeBox/NinePatchRect/Label.text =  str(act_player.income)
	$CentredGame/Top/TopBar/SalaryBox/NinePatchRect/Label.text =  str(act_player.salary)
	$CentredGame/Bottom/BottomBar/QueueBar.clear_queue()
	for i in range(act_player.queue.size()):
		$CentredGame/Bottom/BottomBar/QueueBar.add(act_player.queue[i], i, act_player.progress_actual_troop_in_queue)
	$CentredGame/Bottom/BottomBar/HealthBarBlue/Background/VBoxContainer/HealthBoxBlue.update_health(player1.castle_health)
	$CentredGame/Bottom/BottomBar/HealthBarBlue/Background/VBoxContainer/FoodBox.update_food(player1.food)
	$CentredGame/Bottom/BottomBar/HealthBarRed/Background/VBoxContainer/HealthBoxRed.update_health(player2.castle_health)
	$CentredGame/Bottom/BottomBar/HealthBarRed/Background/VBoxContainer/FoodBox.update_food(player2.food)
	yield()

# Set fields for selecting the castle for the given player
func activate_castle_mode(is_player1: bool) -> void:
	var castle_fields: Array
	castle_fields = get_tree().get_nodes_in_group(Group.castle_field(is_player1))
	
	for field in castle_fields:
		field.set_disabled(false)
	emit_signal("gui_ready")

# Activates create buttons and make all fields with own troops on int selectable
func activate_turn_mode(is_player1: bool) -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		button.set_disabled(false)
	
	for field in get_tree().get_nodes_in_group(Group.FIELDS):
		field.set_disabled(true)

	for field in get_tree().get_nodes_in_group(Group.stationed_troop(is_player1)):
		if field.stationed_troop != null:
			if field.stationed_troop.movement_left > 0:
				field.field_state = FieldState.TROOP_SELECTION
				field.set_disabled(false)
				field.pressed = false
		else:
			print("Kritisch!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! statined troop = null")
	yield()

# Disables everything 
func disable_all() -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		button.set_disabled(true)
	
	disable_battlefield()
	
	for field in get_tree().get_nodes_in_group(Group.QUEUE_BUTTON):
		field.set_disabled(true)

# Disables all fields
func disable_battlefield() -> void:
	for field in get_tree().get_nodes_in_group(Group.FIELDS):
		field.set_disabled(true)

# Add given TroopType to queue
func add_to_queue(troop_type: int) -> void:
	$CentredGame/Bottom/BottomBar/QueueBar.add(troop_type)

# Starts the Round Timer in the TimeBox  with a message 
# And the signal which should get emitted at the end
func start_timer_with_message(message: String, seconds: float, finish_signal: String) -> void:
	show_message(message, GameSettings.message_show_time)
	$CentredGame/Top/TopBar/TimeBox.start_timer(seconds, finish_signal)

# Shows a message for the given time 
func show_message(message: String, seconds: float) -> void:
	if $CentredGame.has_node("MessageContainer"):
		$CentredGame.remove_child($CentredGame.get_node("MessageContainer"))
		
	var msg_container = MESSAGE_CONTAINER.instance()
	$CentredGame.add_child(msg_container)
	msg_container.get_node("MarginContainer/Label").text = message
	yield(get_tree().create_timer(seconds), "timeout")
	if $CentredGame.has_node("MessageContainer"):
		$CentredGame.remove_child($CentredGame.get_node("MessageContainer"))
	
func stop_timer() -> void:
	$CentredGame/Top/TopBar/TimeBox.stop_timer()

# Pause the time and instance the Settings Window
func _on_SettingsButton_pressed() -> void:
	$CentredGame/Top/TopBar/TimeBox.pause_timer()
	var settings: Node = SETTINGS_SCENE.instance()
	var _err = settings.connect("close", self, "_on_SettingsWindow_close")
	$Overlay.add_child(settings)

# Remove the Settings Window and resume the Timer
func _on_SettingsWindow_close(window: Node) -> void:
	$Overlay.remove_child(window)
	$CentredGame/Top/TopBar/TimeBox.resume_timer()

func _on_CloseButton_pressed():
	$Gamelogic.close_game()

func _on_Gamelogic_game_finished(player: Player) -> void:
	emit_signal("game_finished", player)
