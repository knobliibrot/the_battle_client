extends Node

signal castle_set
signal turn_finished


var battlefield_map: Array setget ,get_battlefield_map
var player1: Player
var player2: Player

var actual_player: Player
var is_player1: bool

func initialize_game(player1: int, player2: int) -> void: 
	self.player1 = Player.new()
	self.player1.init(player1)
	self.player1.player_name= "Sämi"
	self.player2 = Player.new()
	self.player2.init(player2)	
	self.player2.gold = 3000

func choose_castel(is_player1: bool) -> void:
	set_actual_player(is_player1)
	
	if is_player1 || self.actual_player.player_type == PlayerTypeEnum.MANUAL:
		get_parent().update_gui_with_player(actual_player)
		get_parent().activate_castle_mode(is_player1)
		get_parent().start_timer_with_message("Place your Castle " + actual_player.player_name + "!", GameParameters.ROUND_TIME, "set_castle_timer_finished")	
		
func start_turn(is_player1: bool) -> void:
	set_actual_player(is_player1)
	if is_player1 || self.actual_player.player_type == PlayerTypeEnum.MANUAL:
		get_parent().update_gui_with_player(actual_player)
		get_parent().activate_turn_mode(is_player1, actual_player)
		get_parent().start_timer_with_message("Your turn " + actual_player.player_name + "!", GameParameters.ROUND_TIME, "turn_finished")	
	
	
func set_actual_player(is_player1: bool) -> void:
	self.is_player1 = is_player1
	if is_player1:
		self.actual_player = player1
	else:
		self.actual_player = player2
		
func set_castle(position: Vector2, is_timeout: bool) -> void:
	var nodes: Array 
	if self.is_player1:
		nodes = get_tree().get_nodes_in_group("castle_field_1")
		if is_timeout:
			position.y = GameParameters.DEFAULT_CASTLE_HEIGHT
			position.x = GameParameters.BATTLEFIELD_WIDTH-1
	else:
		nodes = get_tree().get_nodes_in_group("castle_field_2")
		if is_timeout:
			position.y = GameParameters.DEFAULT_CASTLE_HEIGHT
			position.x = 0
	
	for field in nodes:
		if position == field.get_field_position():
			get_parent().get_node("Battlefield").initalize_given_field(field, FieldTypeEnum.CASTLE) 
		else:
			get_parent().get_node("Battlefield").remove_child(field)
	
	get_parent().stop_timer()
	emit_signal("castle_set")

func generate_battelfield() -> Array:
	battlefield_map = []
	battlefield_map.resize(7)
	for y in range(GameParameters.BATTLEFIELD_HEIGHT):
		var row: Array = []
		row.resize(GameParameters.BATTLEFIELD_WIDTH)
		battlefield_map[y] = row
		for x in range(GameParameters.BATTLEFIELD_WIDTH):
			# Fields should be just at positions where x + y is uneven and not in the first and last column
			if (x + y) % 2 == 1:
				if x != 0 and x != GameParameters.BATTLEFIELD_WIDTH - 1:
					battlefield_map[y][x] = get_parent().get_node("Battlefield").initalize_field(Vector2(x,y), choose_field_type(x, y)) 
					
				else:
					battlefield_map[y][x] = get_parent().get_node("Battlefield").initalize_field(Vector2(x,y), FieldTypeEnum.EMPTY) 
	return battlefield_map

func choose_field_type(x, y) -> int:
	var field_percantage_map: Dictionary = {
	FieldTypeEnum.GRASS:0,
	FieldTypeEnum.FOREST:0,
	FieldTypeEnum.MOUNTAIN:0,
	FieldTypeEnum.VILLAGE:0}
	var neigbour_counter_map: Dictionary = {
	FieldTypeEnum.GRASS:0,
	FieldTypeEnum.FOREST:0,
	FieldTypeEnum.MOUNTAIN:0,
	FieldTypeEnum.VILLAGE:0}
	
	# First Field
	if x == 1 and y == 0:
		set_percentage_start(field_percantage_map)
	else:
		# First Row
		if y == 0:
			count_neighbour(x-2, y, neigbour_counter_map)
		# First Column form Battlefield without castles
		elif x == 1:
			count_neighbour(2, y-1, neigbour_counter_map)
		# Second Column form Battlefield without castles	
		elif x == 2:
			count_neighbour(1, y-1, neigbour_counter_map)
			count_neighbour(3, y-1, neigbour_counter_map)
		else:
			count_neighbour(x-2, y, neigbour_counter_map)
			count_neighbour(x-1, y-1, neigbour_counter_map)
			count_neighbour(x+1, y-1, neigbour_counter_map)
	
	return define_field_type(neigbour_counter_map, field_percantage_map)

func count_neighbour(x, y, neighbour_counter_map) -> void:
	if battlefield_map.find(y) && battlefield_map[y].find(x) && battlefield_map[y][x].get_field_type() != FieldTypeEnum.EMPTY:
		neighbour_counter_map[battlefield_map[y][x].get_field_type()] += 1

func define_field_type(neigbour_counter_map, field_percantage_map) -> int:
	# Set Percentages
	for field_type in neigbour_counter_map:
		var field_amount: int = neigbour_counter_map[field_type]
		if field_type == FieldTypeEnum.GRASS:
			set_percentage_grass(field_percantage_map, field_amount)
				
		elif field_type == FieldTypeEnum.FOREST:
			set_percentage_forest(field_percantage_map, field_amount)
			
		elif field_type == FieldTypeEnum.MOUNTAIN:
			set_percentage_mountain(field_percantage_map, field_amount)
			
		elif field_type == FieldTypeEnum.VILLAGE:
			set_percentage_village(field_percantage_map, field_amount)
	# Pick Random Number
	var total: int = field_percantage_map[FieldTypeEnum.GRASS]  + field_percantage_map[FieldTypeEnum.FOREST] + field_percantage_map[FieldTypeEnum.MOUNTAIN] + field_percantage_map[FieldTypeEnum.VILLAGE]
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var result: int = rng.randi_range(1, total)
	# Return Value amongst the result
	if false:
		print("--------")
		print("Total: " + str(total))
		print("Result: " + str(result))
		print("Grass: " + str(field_percantage_map[FieldTypeEnum.GRASS] ))
		print("Forest: " + str(field_percantage_map[FieldTypeEnum.FOREST] ))
		print("Mountain: " + str(field_percantage_map[FieldTypeEnum.MOUNTAIN] ))
		print("Village: " + str(field_percantage_map[FieldTypeEnum.VILLAGE] ))

	if result < field_percantage_map[FieldTypeEnum.GRASS]:
		return FieldTypeEnum.GRASS
	elif result < field_percantage_map[FieldTypeEnum.FOREST] + field_percantage_map[FieldTypeEnum.GRASS]:
		return FieldTypeEnum.FOREST
	elif result < field_percantage_map[FieldTypeEnum.MOUNTAIN] + field_percantage_map[FieldTypeEnum.FOREST] + field_percantage_map[FieldTypeEnum.GRASS]:
		return FieldTypeEnum.MOUNTAIN
	else:
		return FieldTypeEnum.VILLAGE		

func set_percentage_start(field_percantage_map: Dictionary) -> void:
	field_percantage_map[FieldTypeEnum.GRASS] = GameParameters.START_GRASS_CHANCE
	field_percantage_map[FieldTypeEnum.FOREST] = GameParameters.START_OTHER_CHANCE
	field_percantage_map[FieldTypeEnum.MOUNTAIN] = GameParameters.START_OTHER_CHANCE
	field_percantage_map[FieldTypeEnum.VILLAGE] = GameParameters.START_OTHER_CHANCE

func set_percentage_grass(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] += GameParameters.GRASS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.GRASS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.GRASS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=GameParameters.GRASS_OTHER_CHANCE - 2
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.GRASSTWINS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.GRASSTWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.GRASSTWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.GRASSTWINS_OTHER_CHANCE - 6
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.GRASSTRIPLET_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.GRASSTRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.GRASSTRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.GRASSTRIPLET_OTHER_CHANCE - 10
		
func set_percentage_forest(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.SAME_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.OTHER_CHANCE - 2
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] += GameParameters.TWINS_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=GameParameters.TWINS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=GameParameters.TWINS_OTHER_CHANCE - 6
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.TRIPLET_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=GameParameters.TRIPLET_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=GameParameters.TRIPLET_OTHER_CHANCE - 10
		
func set_percentage_mountain(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=GameParameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] +=GameParameters.SAME_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.OTHER_CHANCE - 2
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.TWINS_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] +=GameParameters.TWINS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.TWINS_OTHER_CHANCE - 6
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] +=GameParameters.TRIPLET_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=GameParameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.TRIPLET_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=GameParameters.TRIPLET_OTHER_CHANCE - 10
		
func set_percentage_village(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] += GameParameters.GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=GameParameters.SAME_CHANCE - 5
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] += GameParameters.TWINS_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.TWINS_SAME_CHANCE - 10
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] += GameParameters.TRIPLET_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += GameParameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += GameParameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += GameParameters.TRIPLET_SAME_CHANCE - 30

func get_battlefield_map() -> Array:
	return battlefield_map

func _on_TimeBox_timeout():
	get_parent().get_node("$Top/TopBar/TimeBox").stop_timer()

func _on_Battlefield_castle_choosen(position: Vector2):
	set_castle(position, false)

func _on_TimeBox_set_castle_timer_finished() -> void:
	set_castle(Vector2(0,1), true)


func _on_TimeBox_turn_finished():
	# TODO: gui
	emit_signal("turn_finished", false)

func _on_CreateTroopButton_create_troop(troop_type):
	print(troop_type)
