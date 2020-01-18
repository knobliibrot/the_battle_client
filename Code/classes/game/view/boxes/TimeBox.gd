extends MarginContainer

signal set_castle_timer_finished
signal turn_finished

var time: int
var actual_time: int
var activity: String

func start_timer(time: int,activity  :String) -> void:
	actual_time = 0
	self.time = time
	self.activity = activity
	$NinePatchRect/Label.text = str(time - actual_time)
	$Timer.start(1)
	
func stop_timer() -> void:
	$Timer.stop()
	$NinePatchRect/Label.text = ""
	
func _on_Timer_timeout() -> void:
	if actual_time < time:
		actual_time += 1
		$NinePatchRect/Label.text = str(time - actual_time)
		$Timer.start(1)
	else:
		emit_signal(activity)
