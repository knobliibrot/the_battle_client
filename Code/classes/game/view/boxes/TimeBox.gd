extends MarginContainer

signal timeout

var time: int
var actual_time: int

func start_timer(time: int) -> void:
	actual_time = 0
	self.time = time
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
		emit_signal("timeout")
