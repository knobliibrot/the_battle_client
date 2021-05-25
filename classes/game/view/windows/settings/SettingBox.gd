extends NinePatchRect

export var label: String
export var class_param: String
export var value_param: String
export var class_sett: String
export var value_sett: String
export var datatype: String

func _ready() -> void:
	$Label.text = self.label
	update()

# Saves the value from the Input in the Settings
func save() -> void:
	set_sett_value(get_node("Input").text)
	update()

# Resets the value in the input to the one from the Parameters
func reset() -> void:
	$Input.text = str(get_param_value())

# Updates the value in the input with the one from the Settings
func update() -> void:
	$Input.text = str(get_sett_value())

# Returns the value of the declared Parameter
func get_param_value():
	return get_node("/root/" + self.class_param).get(self.value_param)

# Returns the value of the declared Settins
func get_sett_value():
	return get_node("/root/" + self.class_sett).get(self.value_sett)

# Set the value in the Settings with the given value
func set_sett_value(new_value) -> void:
	if datatype == "int":
		get_node("/root/" + self.class_sett).set(self.value_sett, int(new_value))
	elif datatype == "float":
		get_node("/root/" + self.class_sett).set(self.value_sett, float(new_value))
	elif datatype == "bool":
		if new_value == "True":
			get_node("/root/" + self.class_sett).set(self.value_sett, true)
		elif new_value == "False":
			get_node("/root/" + self.class_sett).set(self.value_sett, false)
