extends MarginContainer

signal close

# Saves all the settings in the whole window (Not Tab wise)
func _on_SaveButton_pressed() -> void:
	for setting in get_tree().get_nodes_in_group(Group.SETTINGS):
		setting.save()
	emit_signal("close", self)

# Resets all the settings in the whole window (Not Tab wise)
func _on_ResetButton_pressed() -> void:
	for setting in get_tree().get_nodes_in_group(Group.SETTINGS):
		setting.reset()

func _on_CloseButton_pressed() -> void:
	emit_signal("close", self)
