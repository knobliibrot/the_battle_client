extends Node

var battlefield_map: Array
var field_percantage_map: Dictionary = {}
var neigbour_counter_map: Dictionary = {}

# Generates the battlefield randomly
func generate_battlefield() -> Array:
	self.battlefield_map = []
	self.battlefield_map.resize(GameSettings.battlefield_height)
	for y in range(GameSettings.battlefield_height):
		var row: Array = []
		row.resize(GameSettings.battlefield_width)
		battlefield_map[y] = row
		for x in range(GameSettings.battlefield_width):
			# Fields are just at positions where x + y is uneven
			if (x + y) % 2 == 1:
				var field: Field
				# First and last column have just empty fields
				if x != 0 and x != GameSettings.battlefield_width - 1:
					field = get_battlefield().initalize_field(Vector2(x,y), choose_field_type(x, y)) 
				else:
					field = get_battlefield().initalize_field(Vector2(x,y), FieldType.EMPTY) 
					
				initalize_connections(field, x, y)
				self. battlefield_map[y][x] = field
	
	return self.battlefield_map

# Choosse the field type based on the existing neighbours and the field percentages
func choose_field_type(x: int, y :int) -> int:
	self.field_percantage_map = {
		FieldType.GRASS:0,
		FieldType.FOREST:0,
		FieldType.MOUNTAIN:0,
		FieldType.VILLAGE:0
	}
	self.neigbour_counter_map = {
		FieldType.GRASS:0,
		FieldType.FOREST:0,
		FieldType.MOUNTAIN:0,
		FieldType.VILLAGE:0
	}
	
	# First Field
	if x == 1 and y == 0:
		set_percentage_start()
	# Count the field types of the neighbour fields
	else:
		# First Row
		if y == 0:
			count_field_as_neighbour(x-2, y)
		# First Column form Battlefield without castles
		elif x == 1:
			count_field_as_neighbour(2, y-1)
		# Second Column form Battlefield without castles	
		elif x == 2:
			count_field_as_neighbour(1, y-1)
			count_field_as_neighbour(3, y-1)
		else:
			count_field_as_neighbour(x-2, y)
			count_field_as_neighbour(x-1, y-1)
			count_field_as_neighbour(x+1, y-1)
	
	return define_field_type_randomly()

func count_field_as_neighbour(x: int, y: int) -> void:
	if self.battlefield_map[y][x].field_type != FieldType.EMPTY:
		self.neigbour_counter_map[self.battlefield_map[y][x].field_type] += 1

# Set the percentages and retun the choosen field type based on a random number
func define_field_type_randomly() -> int:
	# Set Percentages based on neighbours
	set_percentage_grass(neigbour_counter_map[FieldType.GRASS])
	set_percentage_forest(neigbour_counter_map[FieldType.FOREST])
	set_percentage_mountain(neigbour_counter_map[FieldType.MOUNTAIN])
	set_percentage_village(neigbour_counter_map[FieldType.VILLAGE])
	
	# Pick a random number
	var total: int = field_percantage_map[FieldType.GRASS]  + field_percantage_map[FieldType.FOREST] + field_percantage_map[FieldType.MOUNTAIN] + field_percantage_map[FieldType.VILLAGE]
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var result: int = rng.randi_range(1, total)
	
	""" Print for analysis
	if false:
		print("--------")
		print("Total: " + str(total))
		print("Result: " + str(result))
		print("Grass: " + str(field_percantage_map[FieldType.GRASS] ))
		print("Forest: " + str(field_percantage_map[FieldType.FOREST] ))
		print("Mountain: " + str(field_percantage_map[FieldType.MOUNTAIN] ))
		print("Village: " + str(field_percantage_map[FieldType.VILLAGE] ))
	"""

	# Return Value amongst the result
	if result < field_percantage_map[FieldType.GRASS]:
		return FieldType.GRASS
	elif result < field_percantage_map[FieldType.FOREST] + field_percantage_map[FieldType.GRASS]:
		return FieldType.FOREST
	elif result < field_percantage_map[FieldType.MOUNTAIN] + field_percantage_map[FieldType.FOREST] + field_percantage_map[FieldType.GRASS]:
		return FieldType.MOUNTAIN
	else:
		return FieldType.VILLAGE		

func set_percentage_start() -> void:
	self.field_percantage_map[FieldType.GRASS] = GameSettings.start_grass_chance
	self.field_percantage_map[FieldType.FOREST] = GameSettings.start_other_chance
	self.field_percantage_map[FieldType.MOUNTAIN] = GameSettings.start_other_chance
	self.field_percantage_map[FieldType.VILLAGE] = GameSettings.start_other_chance

func set_percentage_grass(field_amount: int) -> void:
	if field_amount == 1:
		self.field_percantage_map[FieldType.GRASS] += GameSettings.grass_same_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.grass_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.grass_other_chance
		self.field_percantage_map[FieldType.VILLAGE] +=GameSettings.grass_other_chance - 2
	elif field_amount == 2:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.grasstwins_same_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.grasstwins_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.grasstwins_other_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.grasstwins_other_chance - 6
	elif field_amount == 3:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.grasstriplet_same_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.grasstriplet_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.grasstriplet_other_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.grasstriplet_other_chance - 10

func set_percentage_forest(field_amount: int) -> void:
	if field_amount == 1:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.grass_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.same_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.other_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.other_chance - 2
	elif field_amount == 2:
		self.field_percantage_map[FieldType.GRASS] += GameSettings.twins_grass_chance
		self.field_percantage_map[FieldType.FOREST] +=GameSettings.twins_same_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.twins_other_chance
		self.field_percantage_map[FieldType.VILLAGE] +=GameSettings.twins_other_chance - 6
	elif field_amount == 3:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.triplet_grass_chance
		self.field_percantage_map[FieldType.FOREST] +=GameSettings.triplet_same_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.triplet_other_chance
		self.field_percantage_map[FieldType.VILLAGE] +=GameSettings.triplet_other_chance - 10

func set_percentage_mountain(field_amount: int) -> void:
	if field_amount == 1:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.grass_chance
		self.field_percantage_map[FieldType.FOREST] +=GameSettings.other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] +=GameSettings.same_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.other_chance - 2
	elif field_amount == 2:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.twins_grass_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.twins_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] +=GameSettings.twins_same_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.twins_other_chance - 6
	elif field_amount == 3:
		self.field_percantage_map[FieldType.GRASS] +=GameSettings.triplet_grass_chance
		self.field_percantage_map[FieldType.FOREST] +=GameSettings.triplet_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.triplet_same_chance
		self.field_percantage_map[FieldType.VILLAGE] +=GameSettings.triplet_other_chance - 10

func set_percentage_village(field_amount: int) -> void:
	if field_amount == 1:
		self.field_percantage_map[FieldType.GRASS] += GameSettings.grass_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.other_chance
		self.field_percantage_map[FieldType.VILLAGE] +=GameSettings.same_chance - 5
	elif field_amount == 2:
		self.field_percantage_map[FieldType.GRASS] += GameSettings.twins_grass_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.twins_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.twins_other_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.twins_same_chance - 10
	elif field_amount == 3:
		self.field_percantage_map[FieldType.GRASS] += GameSettings.triplet_grass_chance
		self.field_percantage_map[FieldType.FOREST] += GameSettings.triplet_other_chance
		self.field_percantage_map[FieldType.MOUNTAIN] += GameSettings.triplet_other_chance
		self.field_percantage_map[FieldType.VILLAGE] += GameSettings.triplet_same_chance - 30

# Sets the connections for a field
func initalize_connections(field: Field, x: int, y: int) -> void:
	if x > 1 :
		field.set_connection(self.battlefield_map[y][x-2], FieldConnectionType.LEFT)
		self.battlefield_map[y][x-2].set_connection(field, FieldConnectionType.RIGHT)
	if y != 0:
		if x > 0:
			field.set_connection(self.battlefield_map[y-1][x-1], FieldConnectionType.LEFT_UP)
			self.battlefield_map[y-1][x-1].set_connection(field, FieldConnectionType.RIGHT_DOWN)
		if x < GameSettings.battlefield_width-2:
			field.set_connection(self.battlefield_map[y-1][x+1], FieldConnectionType.RIGHT_UP)
			self.battlefield_map[y-1][x+1].set_connection(field, FieldConnectionType.LEFT_DOWN)
	# Set connection for fields left down to the castles
	if x == GameSettings.battlefield_width - 2 and y % 2 == 0 and y >0:
		field.set_connection(self.battlefield_map[y-1][x+1], FieldConnectionType.RIGHT_UP)
		self.battlefield_map[y-1][x+1].set_connection(field, FieldConnectionType.LEFT_DOWN)

func get_battlefield() -> Battlefield:
	return get_parent().get_parent().get_node("Battlefield") as Battlefield
