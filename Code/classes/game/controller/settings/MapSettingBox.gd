extends "res://classes/game/controller/settings/SettingBox.gd"

export var map_key: String

func get_param_value():
	return get_node("/root/" + self.class_param).get(self.value_param)[get_enum_value(self.map_key)]

func get_sett_value():
	return get_node("/root/" + self.class_sett).get(self.value_sett)[get_enum_value(self.map_key)]

func set_sett_value(new_value) -> void:
	var map: Dictionary = get_node("/root/" + self.class_sett).get(self.value_sett)
	
	if datatype == "int":
		map[get_enum_value(self.map_key)] = int(new_value)
	get_node("/root/" + self.class_sett).set(self.value_sett, map)

# Returns the value of the enum regarding to the given key
func get_enum_value(map_key: String) -> int:
	match map_key:
		"GRASS":
			return FieldType.GRASS
		"FOREST":
			return FieldType.FOREST
		"MOUNTAIN":
			return FieldType.MOUNTAIN
		"VILLAGE":
			return FieldType.VILLAGE
		"FCASTLE":
			return FieldType.CASTLE
		"EMPTY":
			return FieldType.EMPTY
		"SWORDSMAN":
			return TroopType.SWORDSMAN
		"SPEARMAN":
			return TroopType.SPEARMAN
		"ARCHER":
			return TroopType.ARCHER
		"KNIGHT":
			return TroopType.KNIGHT
		"CATAPULT":
			return TroopType.CATAPULT
		"TCASTLE":
			return TroopType.CASTLE
	return -1
