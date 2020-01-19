extends MarginContainer

signal remove_from_queue

func add(troop_type: int, position: int, troop_progress: int) -> void:
	var queue_button: QueueButton = load(TroopType.SCENE_QUEUE[troop_type]).instance()
	queue_button.position = position
	queue_button.connect("remove_from_queue", self, "_on_QueueButton_remove_from_queue")
	if position == 0:
		queue_button.get_node("Progress").value = troop_progress
		queue_button.get_node("Progress").max_value = TroopType.BUILD_TIME[troop_type]
	$Background/QueueBox/MarginContainer2/Queue.add_child(queue_button, false)
	
func clear_queue() -> void:
	for item in $Background/QueueBox/MarginContainer2/Queue.get_children():
		$Background/QueueBox/MarginContainer2/Queue.remove_child(item)
		
func _on_QueueButton_remove_from_queue(position: int) -> void:
	emit_signal("remove_from_queue", position)