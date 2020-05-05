extends MarginContainer

func _ready() -> void:
	$Food.value = GameSettings.max_food_amount
	$Food.max_value = GameSettings.max_food_amount

func update_food(food: int) -> void:
	$Food.value = food
	$Food.max_value = GameSettings.max_food_amount
	$Label.text = str(food) + " / " + str(GameSettings.max_food_amount)
