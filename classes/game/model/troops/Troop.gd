extends Node2D

class_name Troop

signal target_pos_reached
signal move_finished
signal animation_finished

var troop_type: int
var healthpoints: int
var movement_left: int
var attack_done: bool
var is_player1: bool
var parent_field

var movement: Vector2
var final_pos: Vector2
var moving: bool = false

# Moves the field if ther is a movement on going until the final_pos is reached
func _process(delta: float):
	if moving and is_final_pos_reached():
		moving = false
		self.set_position(self.final_pos)
		emit_signal("target_pos_reached")
	elif moving:
		self.set_position(self.get_position() + (self.movement * delta / GameSettings.animation_speed_per_field))

# Checkes if the final pos is reached with a bit of tolerance
func is_final_pos_reached() -> bool:
	var reached: bool = false
	var act_pos: Vector2 = self.get_position()
	if movement.x > 0:
		if act_pos.x > self.final_pos.x - GameSettings.animation_tolerance:
			reached = true
	elif movement.x < 0:
		if act_pos.x < self.final_pos.x + GameSettings.animation_tolerance:
			reached = true
	if movement.y > 0:
		if act_pos.y > self.final_pos.y - GameSettings.animation_tolerance:
			reached = true
	elif movement.y < 0:
		if act_pos.y < self.final_pos.y + GameSettings.animation_tolerance:
			reached = true
	return reached

# Goes through the path and makes together with _process the movement
func move(path: Array) -> void:
	for movement in path:
		match movement:
			FieldConnectionType.LEFT_UP:
				self.movement.y = -1 * GameParameters.MOVEMENT_Y
				self.movement.x = -1 * GameParameters.MOVEMENT_X
			FieldConnectionType.RIGHT_UP:
				self.movement.y = -1 * GameParameters.MOVEMENT_Y
				self.movement.x = 1 * GameParameters.MOVEMENT_X
			FieldConnectionType.LEFT:
				self.movement.x = -1 * GameParameters.MOVEMENT_X * 2
				self.movement.y = 0
			FieldConnectionType.RIGHT:
				self.movement.x = 1 * GameParameters.MOVEMENT_X * 2
				self.movement.y = 0
			FieldConnectionType.LEFT_DOWN:
				self.movement.y = 1 * GameParameters.MOVEMENT_Y
				self.movement.x = -1 * GameParameters.MOVEMENT_X
			FieldConnectionType.RIGHT_DOWN:
				self.movement.y = 1 * GameParameters.MOVEMENT_Y
				self.movement.x = 1 * GameParameters.MOVEMENT_X
		self.moving = true
		self.final_pos = self.get_position() + self.movement
		yield(self, "target_pos_reached")
	emit_signal("move_finished")

# Displays the healthpoints in the healthbar
func update_helathpoints() -> void:
	$Container/MarginContainer/TextureProgress.value = self.healthpoints
	$Container/MarginContainer/TextureProgress/Label.text = str(self.healthpoints) + " / " + str($Container/MarginContainer/TextureProgress.max_value)

# Healthpoints are saved in TextureProgress.value
func get_healthpoints() -> int:
	return self.healthpoints

# Healthpoints are saved in TextureProgress.value
func set_healthpoints(value: int) -> void:
	self.healthpoints = value

# Healthpoints are saved in TextureProgress.value
func set_start_healthpoints(value: int) -> void:
	self.healthpoints = value
	$Container/MarginContainer/TextureProgress.value = value
	$Container/MarginContainer/TextureProgress.max_value = value
	$Container/MarginContainer/TextureProgress/Label.text = str(value) + " / " + str(value)

func start_attack_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("attacker_start_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("attacker_start_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("attacker_start_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("attacker_start_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("attacker_start_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("attacker_start_right_up")

func start_defend_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("defender_start_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("defender_start_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("defender_start_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("defender_start_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("defender_start_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("defender_start_right_up")

func attack_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("attack_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("attack_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("attack_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("attack_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("attack_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("attack_right_up")

func defend_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("defend_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("defend_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("defend_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("defend_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("defend_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("defend_right_up")

func die_animation() -> void:
	$TroopAnimation.play("die")

func end_attack_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("attacker_end_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("attacker_end_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("attacker_end_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("attacker_end_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("attacker_end_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("attacker_end_right_up")

func win_attack_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("attacker_win_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("attacker_win_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("attacker_win_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("attacker_win_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("attacker_win_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("attacker_win_right_up")

func end_defend_animation(direction: int) -> void:
	match direction:
		FieldConnectionType.LEFT:
			$TroopAnimation.play("defender_end_left")
		FieldConnectionType.LEFT_DOWN:
			$TroopAnimation.play("defender_end_left_down")
		FieldConnectionType.LEFT_UP:
			$TroopAnimation.play("defender_end_left_up")
		FieldConnectionType.RIGHT:
			$TroopAnimation.play("defender_end_right")
		FieldConnectionType.RIGHT_DOWN:
			$TroopAnimation.play("defender_end_right_down")
		FieldConnectionType.RIGHT_UP:
			$TroopAnimation.play("defender_end_right_up")

func _on_TroopAnimation_animation_finished(_anim_name: String) -> void:
	emit_signal("animation_finished")
