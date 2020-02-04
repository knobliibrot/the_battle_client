extends Node

class_name Player

var player_name: String
var player_type: int
var is_player1: bool

var gold: int
var income: int
var salary: int

var castle_position: Vector2
var castle_health: int
var troops: Array = []

var queue: Array = []
var progress_actual_troop_in_queue: int

# Set start values
func init(type: int, is_player1: bool) -> void:
	if is_player1:
		self.player_name = "Player 1"
	else:
		self.player_name = "Player 2"
		
	self.player_type = type
	self.castle_health = GameSettings.castle_health
	self.gold = GameSettings.start_gold
	self.income = GameSettings.basic_income
	self.salary = 0

# Adds troop to queue if not full
# Returns bool if creation was possible
func add_troop_to_queue(troop_type: int) -> bool:
	var queue_size: int = queue.size()
	if queue_size < GameSettings.queue_size:
		queue.resize(queue_size + 1)
		queue[queue_size] = troop_type
		return true
	else:
		return false

#Removes the troop at the given position from the queue
func remove_from_queue(pos: int) -> void:
	self.gold += TroopSettings.price[queue[pos]]
	queue.remove(pos)
	if pos == 0:
		progress_actual_troop_in_queue = 0

# Removes the given Troop from the Battlefield and updates the salary
func remove_troop(troop: Troop) -> void:
	troops.remove(troops.find(troop))
	salary -= TroopSettings.salary[troop.troop_type]
	income += TroopSettings.salary[troop.troop_type]
	troop.get_parent().remove_stationed_troop()

# If a troop in the queue is ready it returns their troop type.
# Otherwise -1
func get_new_troop() -> int:
	var queue_size: int = queue.size()
	if queue_size > 0:
		if TroopSettings.build_time[queue[0]] - progress_actual_troop_in_queue == 1:
			var new_troop_type: int = queue.pop_front()			
			progress_actual_troop_in_queue = 0
			return new_troop_type
		progress_actual_troop_in_queue += 1
	return -1

func get_battlefield() -> Battlefield:
	return get_parent() as Battlefield