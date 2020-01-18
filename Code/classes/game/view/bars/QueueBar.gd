extends MarginContainer

func add(player_type: int) -> void:
	$Background/QueueBox/MarginContainer2/Queue.add_child(load(TroopType.SCENE_QUEUE[player_type]).instance(), false)
	
func clear_queue() -> void:
	for item in $Background/QueueBox/MarginContainer2/Queue.get_children():
		$Background/QueueBox/MarginContainer2/Queue.remove_child(item)