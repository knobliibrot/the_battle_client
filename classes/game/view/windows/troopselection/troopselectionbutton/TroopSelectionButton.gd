extends MarginContainer

class_name TroopselectionButton

signal pressed

export var troop_type: int 

func _ready() -> void:
	$Button/VBoxContainer/TitelContainer/Label.text = TroopSettings.troop_name[troop_type]
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/HP_v.text = String(TroopSettings.start_health[troop_type])
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/DefDamage_v.text = String(TroopSettings.def_dmg[troop_type])
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/AttDamage_v.text = String(TroopSettings.att_dmg[troop_type])
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/Price_v.text = String(TroopSettings.price[troop_type])
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/Salary_v.text = String(TroopSettings.salary[troop_type])
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/BuildTime_v.text = String(TroopSettings.build_time[troop_type])
	$Button/VBoxContainer/HBoxContainer/InfoBox/Grid/Speed_v.text = String(TroopSettings.fpr[troop_type])
	set_bonus_fields(troop_type)
	set_bonus_troops(troop_type)

func set_pressed(value: bool) -> void:
	$Button.set_pressed(value)

func _on_Button_pressed():
	emit_signal("pressed", self.troop_type, $Button.pressed)

func set_bonus_troops(troop_type: int) -> void:
	for bonus_troop in TroopSettings.special_dmg[troop_type]:
		var node: Node = $Button/VBoxContainer/HBoxContainer/InfoBox/MarginContainer/TroopBonusBox/HBoxContainer.get_node(TroopSettings.troop_name[bonus_troop])
		node.set_visible(true)
		node.hint_tooltip = String(TroopSettings.special_dmg[troop_type][bonus_troop])

func set_bonus_fields(troop_type: int) -> void:
	for bonus_field in TroopSettings.field_att_dmg[troop_type]:
		if (bonus_field != FieldType.MOUNTAIN and bonus_field != FieldType.CASTLE or
		(bonus_field == FieldType.MOUNTAIN and 
		TroopSettings.field_att_dmg[troop_type][bonus_field] / -2 != TroopSettings.salary[troop_type] ) or
		(bonus_field == FieldType.CASTLE and 
		TroopSettings.field_att_dmg[troop_type][bonus_field] / -4 != TroopSettings.salary[troop_type] )
		):
			var node: Node = $Button/VBoxContainer/HBoxContainer/InfoBox/Grid/BonusFields.get_node(FieldSettings.field_name[bonus_field] + "_att")
			node.set_visible(true)
			node.hint_tooltip = String(TroopSettings.field_att_dmg[troop_type][bonus_field])
	for bonus_field in TroopSettings.field_def_dmg[troop_type]:
		if (bonus_field != FieldType.MOUNTAIN and bonus_field != FieldType.CASTLE or
		(bonus_field == FieldType.MOUNTAIN and 
		TroopSettings.field_def_dmg[troop_type][bonus_field] / 2 != TroopSettings.salary[troop_type] ) or
		(bonus_field == FieldType.CASTLE and 
		TroopSettings.field_def_dmg[troop_type][bonus_field] / 4 != TroopSettings.salary[troop_type] )
		):
			var node: Node = $Button/VBoxContainer/HBoxContainer/InfoBox/Grid/BonusFields.get_node(FieldSettings.field_name[bonus_field] + "_def")
			node.set_visible(true)
			node.hint_tooltip = String(TroopSettings.field_def_dmg[troop_type][bonus_field])


