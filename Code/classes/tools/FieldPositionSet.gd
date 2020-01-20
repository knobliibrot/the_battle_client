extends Node


const FIELD_DISTANCE_LIST = preload("res://classes/tools/FieldDistanceList.tscn")

var set: Array = []

func add_new(distance, new_item: Field) -> void:
	if set.size() == 0:
		var dist_list = FIELD_DISTANCE_LIST.instance()
		dist_list.distance = distance
		dist_list.dict[new_item.field_position] = new_item
		set.append(dist_list)
	else:
		for i in range(set.size()):
			if distance < set[i].distance:
				var dist_list = FIELD_DISTANCE_LIST.instance()
				dist_list.distance = distance
				dist_list.dict[new_item.field_position] = new_item
				set.insert(i, dist_list)
				break
			elif distance == set[i].distance:
				set[i].dict[new_item.field_position] = new_item
				break
			elif i + 1 == set.size():
				var dist_list = FIELD_DISTANCE_LIST.instance()
				dist_list.distance = distance
				dist_list.dict[new_item.field_position] = new_item
				set.insert(set.size(), dist_list)
			
func change_existing(new_distance, item: Field) -> void:
	for dist in set:
		if dist.distance == item.dijk_distance:
			dist.pop(item.field_position)
		if dist.dict.size() == 0:
			set.erase(dist)
	item.dijk_distance = new_distance
	add_new(new_distance, item)
	
func pop_first() -> Field:
	if !is_empty():
		var field = set[0].pop_first()
		if set[0].dict.size() == 0:
			set.pop_front()
		return field
	return null
	
func is_empty() -> bool:
	if set.size() > 0:
		return false
	else:
		return true