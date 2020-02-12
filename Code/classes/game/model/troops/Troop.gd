extends MarginContainer

class_name Troop

signal target_pos_reached
signal move_finished
signal animation_finished

var troop_type: int
var healthpoints: int
var movement_left: int
var is_player1: bool

var movement: Vector2
var pixel_left: Vector2
var final_pos: Vector2
var move = false

func _process(delta):
	if move and abs_pos(self.pixel_left) <= Vector2(10,10):
		move = false
		self._set_position(self.final_pos)
		emit_signal("target_pos_reached")
	elif move:
		self._set_position(self.get_position() + (self.movement * delta / 0.2))
		self.pixel_left -= (self.movement * delta / 0.2)

func move(path: Array) -> void:
	get_parent().get_parent().move_child(get_parent(), get_parent().get_parent().get_children().size()-1)
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
		self.move = true
		self.final_pos = self.get_position() + self.movement
		self.pixel_left = self.movement
		yield(self, "target_pos_reached")
	emit_signal("move_finished")

func abs_pos(pos: Vector2) -> Vector2:
	if pos.x < 0:
		pos.x = pos.x * -1
	if pos.y < 0:
		pos.y = pos.y * -1
	return pos 

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
	$TroopAnimation.play("attack_left_up")

func die_animation() -> void:
	$TroopAnimation.play("die")

func end_defend_animation(direction: int) -> void:
	$TroopAnimation.play("defender_end_left_up")

func end_attack_animation(direction: int) -> void:
	$TroopAnimation.play("attacker_end_left_up")

func _on_TroopAnimation_animation_finished(anim_name: String) -> void:
	emit_signal("animation_finished")

func update_helathpoints() -> void:
	$MarginContainer/TextureProgress.value = self.healthpoints
	$MarginContainer/TextureProgress/Label.text = str(self.healthpoints) + " / " + str($MarginContainer/TextureProgress.max_value)

# Healthpoints are saved in TextureProgress.value
func get_healthpoints() -> int:
	return self.healthpoints

# Healthpoints are saved in TextureProgress.value
func set_healthpoints(value: int) -> void:
	self.healthpoints = value

# Healthpoints are saved in TextureProgress.value
func set_start_healthpoints(value: int) -> void:
	self.healthpoints = value
	$MarginContainer/TextureProgress.value = value
	$MarginContainer/TextureProgress.max_value = value
	$MarginContainer/TextureProgress/Label.text = str(value) + " / " + str(value)
