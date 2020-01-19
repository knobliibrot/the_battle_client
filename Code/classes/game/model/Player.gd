extends Node

class_name Player

var player_name: String
var player_type: int
var castle_position: Vector2
var castle_health: int
var gold: int
var income: int
var salary: int
var troops: Array
var queue: Array = []
var progress_actual_troop_in_queue: int

func init(type: int) -> void:
	self.player_name = "Player"
	self.player_type = type
	self.castle_health = GameParameters.DEFAULT_CASTLE_HEALTH
	self.gold = GameParameters.DEFAULT_START_GOLD
	self.income = GameParameters.DEFAULT_BASIC_INCOME
	self.salary = 0
	
func remove_from_queue(position: int) -> void:
	queue.remove(position)
	if position == 0:
		progress_actual_troop_in_queue = 0
	
func add_troop_to_queue(troop_type: int) -> bool:
	var queue_size: int = queue.size()
	if queue_size < GameParameters.QUEUE_SIZE:
		queue.resize(queue_size + 1)
		queue[queue_size] = troop_type
		return true
	else:
		return false
	
func get_new_troop() -> int:
	var queue_size: int = queue.size()
	if queue_size > 0:
		if TroopType.BUILD_TIME[queue[0]] - progress_actual_troop_in_queue == 1:
			var new_troop: int = queue[0]
			queue.pop_front()
			progress_actual_troop_in_queue = 0
			return new_troop
		progress_actual_troop_in_queue += 1
	return -1