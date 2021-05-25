extends Node

class_name Playground

signal gui_ready
signal game_finished

const MESSAGE_CONTAINER = preload("res://classes/game/view/boxes/MessageContainer.tscn")
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
	yield()

# Set fields for selecting the castle for the given player
func activate_castle_choosing(is_player1: bool) -> void:
	var castle_fields: Array
	castle_fields = get_tree().get_nodes_in_group(Group.castle_field(is_player1))
	
	for field in castle_fields:
		field.set_disabled(false)
	emit_signal("gui_ready")

# Shows all the game ui boxes and makes the start ui boxes invisible
func start_game_mode() -> void:
	for ui in get_tree().get_nodes_in_group(Group.GAME_MODE_UI_NODE):
		ui.set_visible(true)
	
	for ui in get_tree().get_nodes_in_group(Group.INITIAL_MODE_UI_NODE):
		ui.set_visible(false)

# Activates create buttons and make all fields with own troops on int selectable
func activate_turn_mode(is_player1: bool, actual_player: Player) -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		if  actual_player.selected_troops.has(button.troop_type):
			button.get_node("TextureButton").set_disabled(false)
	
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
	
	$CentredGame/Top/TopBar/TopBar2/DoneBox/NinePatchRect/Button.set_disabled(true)

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

# Shows a message for the given time 
func show_message(message: String) -> void:
	$CentredGame/Top/TopBar/MessageBox/Box/Label.text = message

func stop_timer() -> void:
	$CentredGame/Top/TopBar/TopBar2/TimeBox.stop_timer()

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

func _on_CloseButton_pressed():
	$Gamelogic.close_game()

func _on_Gamelogic_game_finished(player: Player) -> void:
	emit_signal("game_finished", player)

func _on_SelectTroopsButton_pressed():
	$CentredGame/Overlay/TroopselectionWindow.set_selected_troops($Gamelogic.act_player.selected_troops)
	$CentredGame/Overlay/TroopselectionWindow.set_visible(true)

func _on_TroopselectionWindow_close() -> void:
	$CentredGame/Overlay/TroopselectionWindow.set_visible(false)

func _on_TroopinfoWindow_close() -> void:
	$CentredGame/Overlay/TroopinfoWindow.set_visible(false)

func _on_TroopselectionWindow_refresh(selected_troops: Array, message: String) -> void:
	for button in get_tree().get_nodes_in_group(Group.CREATE_TROOP_BUTTON):
		if  selected_troops.has(button.troop_type):
			button.set_visible(true)
		else:
			button.set_visible(false)
	if !message.empty():
		show_message(message)

func _on_InfoButton_pressed():
	$CentredGame/Overlay/TroopinfoWindow.set_visible(true)
