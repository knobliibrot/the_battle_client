extends MarginContainer

signal refresh
signal close

var troop_buttons: Dictionary
# It's a copy from act_player.selected_troops!
var selected_troops: Array

func _ready():
	for button in $Panel/VBoxContainer/GridContainer.get_children():
		troop_buttons[button.troop_type] = button

# Disable all the buttons, add selected troop to players troops and activate
# buttons regarding to selected_troops
func set_selected_troops(selected_troops: Array) -> void:
	for button in troop_buttons.values():
		button.set_pressed(false)
	self.selected_troops = selected_troops
	for troop in selected_troops:
		troop_buttons[troop].set_pressed(true)

func _on_CloseButton_pressed() -> void:
	emit_signal("close")

# Check if more then 5 troops selected, adds or erase bassed on button.pressed and refresh
func _on_TroopSelectionButton_pressed(troop_type: int, pressed: bool) -> void:
	var message: String = ""
	if pressed:
		if selected_troops.size() < 5:
			selected_troops.append(troop_type)
		else:
			troop_buttons[troop_type].set_pressed(false)
			message = "You can select just 5 Troops"
	else:
		selected_troops.erase(troop_type)
	emit_signal("refresh", self.selected_troops, message)
