extends MarginContainer



func _on_SaveButton_pressed():
	for setting in get_tree().get_nodes_in_group(Group.SETTINGS):
		setting.save()
	get_parent().remove_child(self)


func _on_ResetButton_pressed():
	for setting in get_tree().get_nodes_in_group(Group.SETTINGS):
		setting.reset()


func _on_CloseButton_pressed():
	get_parent().remove_child(self)
