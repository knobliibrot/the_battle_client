extends MarginContainer

class_name CreateTroopButton

signal create_troop

var troop_type: int

func _on_TextureButton_pressed() -> void:
	emit_signal("create_troop", troop_type)

func set_hint() -> void:
	$TextureButton.set_tooltip(("Price:  " + str(TroopSettings.price[troop_type]) +
		"\nBuild Time:  " + str(TroopSettings.build_time[troop_type]) +
		"\nSalary:  " + str(TroopSettings.salary[troop_type]) +
		"\nSpeed:  " + str(TroopSettings.fpr[troop_type]) +
		"\nHealth:  " + str(TroopSettings.start_health[troop_type]) +
		"\nAtt Damage:  " + str(TroopSettings.att_dmg[troop_type]) +
		"\nDef Damage:  " + str(TroopSettings.def_dmg[troop_type])))
