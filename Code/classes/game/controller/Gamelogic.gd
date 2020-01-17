extends Node


const FieldTypeEnum = preload("res://classes/enums/FieldTypeEnum.gd")
const Parameters = preload("res://classes/game/model/Rulebook/GameParameters.gd")
const Field = preload("res://classes/game/model/Field.tscn")

var battlefield_map: Array setget ,get_battlefield_map


func generate_battelfield() -> Array:
	battlefield_map = []
	battlefield_map.resize(7)
	for y in range(Parameters.BATTLEFIELD_HEIGHT):
		var row: Array = []
		row.resize(Parameters.BATTLEFIELD_WIDTH)
		battlefield_map[y] = row
		for x in range(Parameters.BATTLEFIELD_WIDTH):
			# Fields should be just at positions where x + y is uneven and not in the first and last column
			if (x + y) % 2 == 1:
				if x != 0 and x != Parameters.BATTLEFIELD_WIDTH - 1:					
					var field = Field.instance()
					field.set_position(x, y)
					battlefield_map[y][x] = field
					choose_field_type(x, y)
				else:
					var field = Field.instance()
					field.set_position(x, y)
					battlefield_map[y][x] = field
					battlefield_map[y][x].set_field_type(FieldTypeEnum.EMPTY)
	return battlefield_map

func choose_field_type(x, y) -> void:
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
	
	battlefield_map[y][x].set_field_type(define_field_type(neigbour_counter_map, field_percantage_map))

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
	field_percantage_map[FieldTypeEnum.GRASS] = Parameters.START_GRASS_CHANCE
	field_percantage_map[FieldTypeEnum.FOREST] = Parameters.START_OTHER_CHANCE
	field_percantage_map[FieldTypeEnum.MOUNTAIN] = Parameters.START_OTHER_CHANCE
	field_percantage_map[FieldTypeEnum.VILLAGE] = Parameters.START_OTHER_CHANCE

func set_percentage_grass(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] += Parameters.GRASS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.GRASS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.GRASS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=Parameters.GRASS_OTHER_CHANCE - 2
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.GRASSTWINS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.GRASSTWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.GRASSTWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.GRASSTWINS_OTHER_CHANCE - 6
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.GRASSTRIPLET_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.GRASSTRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.GRASSTRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.GRASSTRIPLET_OTHER_CHANCE - 10
		
func set_percentage_forest(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.SAME_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.OTHER_CHANCE - 2
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] += Parameters.TWINS_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=Parameters.TWINS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=Parameters.TWINS_OTHER_CHANCE - 6
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.TRIPLET_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=Parameters.TRIPLET_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=Parameters.TRIPLET_OTHER_CHANCE - 10
		
func set_percentage_mountain(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=Parameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] +=Parameters.SAME_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.OTHER_CHANCE - 2
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.TWINS_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] +=Parameters.TWINS_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.TWINS_OTHER_CHANCE - 6
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] +=Parameters.TRIPLET_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] +=Parameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.TRIPLET_SAME_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=Parameters.TRIPLET_OTHER_CHANCE - 10
		
func set_percentage_village(field_percantage_map: Dictionary, field_amount: int) -> void:
	if field_amount == 1:
		field_percantage_map[FieldTypeEnum.GRASS] += Parameters.GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] +=Parameters.SAME_CHANCE - 5
	elif field_amount == 2:
		field_percantage_map[FieldTypeEnum.GRASS] += Parameters.TWINS_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.TWINS_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.TWINS_SAME_CHANCE - 10
	elif field_amount == 3:
		field_percantage_map[FieldTypeEnum.GRASS] += Parameters.TRIPLET_GRASS_CHANCE
		field_percantage_map[FieldTypeEnum.FOREST] += Parameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.MOUNTAIN] += Parameters.TRIPLET_OTHER_CHANCE
		field_percantage_map[FieldTypeEnum.VILLAGE] += Parameters.TRIPLET_SAME_CHANCE - 30

func get_battlefield_map() -> Array:
	return battlefield_map
	