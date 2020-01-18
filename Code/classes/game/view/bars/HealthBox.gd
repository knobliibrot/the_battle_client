extends MarginContainer

func update_health(health: int) -> void:
	$Health.value = health
	$Label.text = str(health) + " / " + str(GameParameters.DEFAULT_CASTLE_HEALTH)