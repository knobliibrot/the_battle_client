extends "res://classes/game/view/windows/settings/MapSettingBox.gd"

export var second_map_key: String

func get_param_value():
	return get_node("/root/" + self.class_param).get(self.value_param)[get_enum_value(self.map_key)][get_enum_value(self.second_map_key)]

func get_sett_value():
	return get_node("/root/" + self.class_sett).get(self.value_sett)[get_enum_value(self.map_key)][get_enum_value(self.second_map_key)]

func set_sett_value(new_value) -> void:
	var map: Dictionary = get_node("/root/" + self.class_sett).get(self.value_sett)
	
	match datatype:
		"int":
			map[get_enum_value(self.map_key)][get_enum_value(self.second_map_key)] = int(new_value)
		"float":
			map[get_enum_value(self.map_key)][get_enum_value(self.second_map_key)] = float(new_value)
	get_node("/root/" + self.class_sett).set(self.value_sett, map)
