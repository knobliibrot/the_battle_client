extends Node

class_name Playground

signal gui_ready

const CASTLE_SCENE = preload("res://classes/game/model/fields/CastleField.tscn")
const SETTINGS_SCENE = preload("res://classes/game/view/windows/settings/SettingsWindow.tscn")

# Updates the info-, castlehealth- and queue boxes
func update_gui_with_player(player1: Player, player2: Player, act_player: Player) -> void:
	$CentredGame/Overlay/TroopselectionWindow.set_visible(false)
	$CentredGame/Top/TopBar/TopBar2/GoldBox/NinePatchRect/Label.text = str(act_player.gold)
	$CentredGame/Top/TopBar/TopBar2/IncomeBox/NinePatchRect/Label.text =  str(act_player.income)
	$CentredGame/Top/TopBar/TopBar2/SalaryBox/NinePatchRect/Label.text =  str(act_player.salary)
	$CentredGame/Bottom/BottomBar/QueueBar.clear_queue()
	for i in range(act_player.queue.size()):
		$CentredGame/Bottom/BottomBar/QueueBar.add(act_player.queue[i], i, act_player.progress_actual_troop_in_queue)
	$CentredGame/Bottom/BottomBar/HealthBarBlue/Background/VBoxContainer/HealthBoxBlue.update_health(player1.castle_health)
	$CentredGame/Bottom/BottomBar/HealthBarBlue/Background/VBoxContainer/FoodBox.update_food(player1.food)
	$CentredGame/Bottom/BottomBar/HealthBarRed/Background/VBoxContainer/HealthBoxRed.update_health(player2.castle_health)
	$CentredGame/Bottom/BottomBar/HealthBarRed/Background/VBoxContainer/FoodBox.update_food(player2.food)
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		if  act_player.selected_troops.has(button.troop_type):
			button.set_visible(true)
		else:
			button.set_visible(false)
	
	if act_player.player_type == PlayerType.ONLINE:
		for queue_button in get_tree().get_nodes_in_group(Group.QUEUE_BUTTON):
			queue_button.set_disabled(true)
	yield()

# Set fields for selecting the castle for the given player
func activate_castle_choosing(is_player1: bool) -> void:
	var castle_fields: Array
	castle_fields = get_tree().get_nodes_in_group(Group.castle_field(is_player1))
	
	for field in castle_fields:
		field.set_disabled(false)
	emit_signal("gui_ready")

# Mode if the user finished but the opponent didn't in Multiplayer
func wait_for_opponent_initial_round_finished(opponent: Player) -> void:
	show_message("You have to wait until " + opponent.player_name + " has finished the initial round")
	$CentredGame/Top/TopBar/TopBar2/DoneBox.visible = false
	for ui in get_tree().get_nodes_in_group(Group.INITIAL_MODE_UI_NODE):
		ui.set_visible(false)

# Shows all the game ui boxes and makes the start ui boxes invisible
func start_game_mode() -> void:
	for ui in get_tree().get_nodes_in_group(Group.GAME_MODE_UI_NODE):
		ui.set_visible(true)
	
	for ui in get_tree().get_nodes_in_group(Group.INITIAL_MODE_UI_NODE):
		ui.set_visible(false)

# Activates create buttons and make all fields with own troops on int selectable
func activate_turn_mode(is_player1: bool, actual_player: Player) -> void:
	for field in get_tree().get_nodes_in_group(Group.FIELDS):
		field.set_disabled(true)
	
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		if  actual_player.selected_troops.has(button.troop_type):
			if actual_player.player_type == PlayerType.MANUAL:
				button.get_node("TextureButton").set_disabled(false)
			else:
				button.get_node("TextureButton").set_disabled(true)
	
	for field in get_tree().get_nodes_in_group(Group.stationed_troop(is_player1)):
		if field.stationed_troop != null:
			if field.stationed_troop.movement_left > 0:
				field.field_state = FieldState.TROOP_SELECTION
				if actual_player.player_type == PlayerType.MANUAL:
					field.set_disabled(false)
				else:
					field.set_disabled(true)
				field.pressed = false
		else:
			print("Kritisch!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! statined troop = null")
		
	$CentredGame/Top/TopBar/TopBar2/DoneBox.visible = true
	
	if actual_player.player_type == PlayerType.ONLINE:
		$CentredGame/Top/TopBar/TopBar2/DoneBox.visible = false
	
	yield()

# Disables everything 
func disable_all() -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		button.set_disabled(true)
	
	disable_battlefield()
	
	for button in get_tree().get_nodes_in_group(Group.QUEUE_BUTTON):
		button.set_disabled(true)
	
	$CentredGame/Top/TopBar/TopBar2/DoneBox.visible = false

# Disables all fields
func disable_battlefield() -> void:
	for field in get_tree().get_nodes_in_group(Group.FIELDS):
		field.set_disabled(true)

# Add given TroopType to queue
func add_to_queue(troop_type: int) -> void:
	$CentredGame/Bottom/BottomBar/QueueBar.add(troop_type)

# Starts the Round Timer in the TimeBox  with a message 
# And the signal which should get emitted at the end
func start_timer_with_message(message: String, seconds: float) -> void:
	show_message(message)
	$CentredGame/Top/TopBar/TopBar2/TimeBox.start_timer(seconds)

# Set the timer for multiplayer to correct the time
func set_timer(timer_started_time: int) -> void:
	$CentredGame/Top/TopBar/TopBar2/TimeBox.set_timer(timer_started_time)

# Get the time when the timer started
func get_actual_time_started() -> int:
	return $CentredGame/Top/TopBar/TopBar2/TimeBox.actual_time_started

# Stop timer
func stop_timer() -> void:
	$CentredGame/Top/TopBar/TopBar2/TimeBox.stop_timer()

# Shows a message for the given time 
func show_message(message: String) -> void:
	$CentredGame/Top/TopBar/MessageBox/Box/Label.text = message

# Change Button from directl close to give up
func change_close_to_give_up_button() -> void:
	$UI/CloseButton.visible = false
	$UI/GiveUpButton.visible = true

# Show the overlay when the game is finished
func show_game_over_overlay(game_won: bool, connection_broke: bool = false) -> void:
	$CentredGame/Overlay/GameoverWindow.visible = true
	$CentredGame/Overlay/GameoverBackground.visible = true
	if connection_broke:
		$CentredGame/Overlay/GameoverWindow/CenterContainer/VBoxContainer/Label.text = "The connection to the server got lost"
	else:
		if game_won:
			$CentredGame/Overlay/GameoverWindow/CenterContainer/VBoxContainer/Label.text = "You won!!!"
		else:
			$CentredGame/Overlay/GameoverWindow/CenterContainer/VBoxContainer/Label.text = "Game Over!!!"

# Pause the time and instance the Settings Window
func _on_SettingsButton_pressed() -> void:
	$CentredGame/Top/TopBar/TopBar2/TimeBox.pause_timer()
	var settings: Node = SETTINGS_SCENE.instance()
	var _err = settings.connect("close", self, "_on_SettingsWindow_close")
	$CentredGame/Overlay.add_child(settings)

# Remove the Settings Window and resume the Timer
func _on_SettingsWindow_close(window: Node) -> void:
	$CentredGame/Overlay.remove_child(window)
	$CentredGame/Top/TopBar/TopBar2/TimeBox.resume_timer()

func _on_GiveUpButton_pressed() -> void:
	$Gamelogic.give_up()
	print("on_GiveUpButton_pressed")

func _on_CloseButton_pressed() -> void:
	$Gamelogic.close_game()
	print("on_CloseButton_pressed")

func _on_MenuButton_pressed() -> void:
	$Gamelogic.close_game()

# Select a troop in the troopselection window
func _on_SelectTroopsButton_pressed():
	$CentredGame/Overlay/TroopselectionWindow.set_selected_troops($Gamelogic.act_player.selected_troops)
	$CentredGame/Overlay/TroopselectionWindow.set_visible(true)

func _on_TroopselectionWindow_close() -> void:
	$CentredGame/Overlay/TroopselectionWindow.set_visible(false)

func _on_TroopinfoWindow_close() -> void:
	$CentredGame/Overlay/TroopinfoWindow.set_visible(false)

# Refresh the troopselection window with the selected troops
func _on_TroopselectionWindow_refresh(selected_troops: Array, message: String) -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		if  selected_troops.has(button.troop_type):
			button.set_visible(true)
		else:
			button.set_visible(false)
	if !message.empty():
		show_message(message)

func _on_InfoButton_pressed() -> void:
	$CentredGame/Overlay/TroopinfoWindow.set_visible(true)
