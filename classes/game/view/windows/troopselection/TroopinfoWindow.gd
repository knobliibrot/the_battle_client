extends MarginContainer

signal close

var troop_buttons: Dictionary

func _ready():
	for button in $Panel/VBoxContainer/GridContainer.get_children():
		troop_buttons[button.troop_type] = button
		button.get_node("Button").set_disabled(true)

func _on_CloseButton_pressed():
	emit_signal("close")
