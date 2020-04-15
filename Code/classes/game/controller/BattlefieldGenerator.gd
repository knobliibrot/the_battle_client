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
	set_factories()
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
	set_percentage(GameSettings.chances_grass, neigbour_counter_map[FieldType.GRASS])
	set_percentage(GameSettings.chances_forest, neigbour_counter_map[FieldType.FOREST])
	set_percentage(GameSettings.chances_mountain, neigbour_counter_map[FieldType.MOUNTAIN])
	set_percentage(GameSettings.chances_village, neigbour_counter_map[FieldType.VILLAGE])
	
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

# Sets percentages for the first Field
func set_percentage_start() -> void:
	self.field_percantage_map[FieldType.GRASS] = GameSettings.start_grass_chance
	self.field_percantage_map[FieldType.FOREST] = GameSettings.start_other_chance
	self.field_percantage_map[FieldType.MOUNTAIN] = GameSettings.start_other_chance
	self.field_percantage_map[FieldType.VILLAGE] = GameSettings.start_other_chance

# Set pecentages for the given field respective to the field amount
func set_percentage(percentage_map: Dictionary, field_amount: int) -> void:
	if field_amount > 0:
		self.field_percantage_map[FieldType.GRASS] += percentage_map[FieldType.GRASS][field_amount]
		self.field_percantage_map[FieldType.FOREST] += percentage_map[FieldType.FOREST][field_amount]
		self.field_percantage_map[FieldType.MOUNTAIN] += percentage_map[FieldType.MOUNTAIN][field_amount]
		self.field_percantage_map[FieldType.VILLAGE] += percentage_map[FieldType.VILLAGE][field_amount]

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

# Sets the factories at the fixed positions
func set_factories() -> void:
	self.battlefield_map[1][4].add_factory()
	self.battlefield_map[1][16].add_factory()
	self.battlefield_map[3][10].add_factory()
	self.battlefield_map[5][4].add_factory()
	self.battlefield_map[5][16].add_factory()

func get_battlefield() -> Battlefield:
	return get_parent().get_parent().get_node("Battlefield") as Battlefield
