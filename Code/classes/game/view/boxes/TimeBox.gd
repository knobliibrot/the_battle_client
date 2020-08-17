extends MarginContainer

signal timer_finished

var time: int
var actual_time: int

# Sets the final time an activity and starts a timer for one second
func start_timer(timer_time: int) -> void:
	self.actual_time = 0
	self.time = timer_time
	$NinePatchRect/Label.text = str(timer_time - actual_time)
	$Timer.start(1)

func stop_timer() -> void:
	$Timer.stop()
	$NinePatchRect/Label.text = ""

func pause_timer() -> void:
	$Timer.set_paused(true)

func resume_timer() -> void:
	$Timer.set_paused(false)

func _on_Timer_timeout() -> void:
	if actual_time < time:
		actual_time += 1
		$NinePatchRect/Label.text = str(time - actual_time)
		$Timer.start(1)
	else:
		emit_signal("timer_finished")
