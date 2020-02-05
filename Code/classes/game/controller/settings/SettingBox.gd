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

func save() -> void:
	set_sett_value(get_node("Input").text)
	update()

func reset() -> void:
	$Input.text = str(get_param_value())

func update() -> void:
	$Input.text = str(get_sett_value())

func get_param_value():
	return get_node("/root/" + self.class_param).get(self.value_param)

func get_sett_value():
	return get_node("/root/" + self.class_sett).get(self.value_sett)

func set_sett_value(new_value) -> void:
	if datatype == "int":
		get_node("/root/" + self.class_sett).set(self.value_sett, int(new_value))
