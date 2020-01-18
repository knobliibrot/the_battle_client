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

func init(type: int) -> void:
	self.player_name = "Player"
	self.player_type = type
	self.castle_health = GameParameters.DEFAULT_CASTLE_HEALTH
	self.gold = GameParameters.DEFAULT_START_GOLD
	self.income = GameParameters.DEFAULT_BASIC_INCOME
	self.salary = 0
	
func add_troop_to_queue(troop_type: int) -> bool:
	var queue_size: int = queue.size()
	if queue_size < GameParameters.QUEUE_SIZE:
		queue.resize(queue_size + 1)
		queue[queue_size] = troop_type
		return true
	else:
		return false
	