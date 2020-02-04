extends Node

const FIELD_MAP_PER_DISTANCE = preload("res://classes/tools/FieldMapPerDistance.tscn")

# The array gets to a set because of the add_new method
var set: Array = []

# Adds the field into the set regarding to the distance
# Because of this metohd gets the array to a ordered set per distance
# The order is ascending
func add_new(distance: int, new_item: Field) -> void:
	if set.empty():
		set.append(create_field_map_with_field(distance, new_item))
	else:
		for i in range(set.size()):
			if distance < set[i].distance:
				set.insert(i, create_field_map_with_field(distance, new_item))
				break
			elif distance == set[i].distance:
				set[i].dict[new_item.field_position] = new_item
				break
			elif i + 1 == set.size():
				set.insert(set.size(), create_field_map_with_field(distance, new_item))

# Returns a field map with the given distance and the field is already inserted
func create_field_map_with_field(distance: int, new_item: Field) -> FieldMapPerDistance:
	var dist_map = FIELD_MAP_PER_DISTANCE.instance()
	dist_map.distance = distance
	dist_map.dict[new_item.field_position] = new_item
	return dist_map

# Gets the searched field, deletes it from the distance map, changes the distance in the field and add it new to the set
# If the distance map is empty delete it out of the set
func change_existing(new_distance: int, item: Field) -> void:
	for dist_map in set:
		if dist_map.distance == item.dijk_distance:
			dist_map.erase(item.field_position)
		if dist_map.dict.empty():
			set.erase(dist_map)
	item.dijk_distance = new_distance
	add_new(new_distance, item)

# Pops one field of the smallest distance
func pop_first_field() -> Field:
	if !set.empty():
		var field = set[0].pop_first()
		if set[0].dict.empty():
			set.pop_front()
		return field
	return null