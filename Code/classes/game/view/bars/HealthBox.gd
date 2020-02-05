extends MarginContainer

func _ready() -> void:
	$Health.value = GameSettings.castle_health
	$Health.max_value = GameSettings.castle_health

func update_health(health: int) -> void:
	$Health.value = health
	$Health.max_value = GameSettings.castle_health
	$Label.text = str(health) + " / " + str(GameSettings.castle_health)
