extends MarginContainer

signal timer_finished

var time: int
var actual_time: int
var actual_time_started: int

# Sets the final time an activity and starts a timer for one second
func start_timer(timer_time: int, start_time: int = 0) -> void:
	self.actual_time = start_time
	self.time = timer_time
	$NinePatchRect/Label.text = str(timer_time - actual_time)	
	actual_time_started = OS.get_system_time_msecs()
	$Timer.start(1)

func set_timer(timer_started_time: int) -> void:
	$Timer.stop()
	start_timer(self.time, int(round(float(OS.get_system_time_msecs() - timer_started_time)/1000)))

func stop_timer() -> void:
	$Timer.stop()
	$NinePatchRect/Label.text = ""

func pause_timer() -> void:
	$Timer.set_paused(true)

func resume_timer() -> void:
	$Timer.set_paused(false)

# Change every second the time displayed
func _on_Timer_timeout() -> void:
	if actual_time < time:
		actual_time += 1
		$NinePatchRect/Label.text = str(time - actual_time)
		actual_time_started = OS.get_system_time_msecs()
		$Timer.start(1)
	else:
		emit_signal("timer_finished")
