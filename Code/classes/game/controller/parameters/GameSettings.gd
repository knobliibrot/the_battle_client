extends Node

# Battelfield Generation Parameters
var start_grass_chance: int = GameParameters.START_GRASS_CHANCE
var start_other_chance: int = GameParameters.START_OTHER_CHANCE

var chances_grass: Dictionary = GameParameters.CHANCES_GRASS
var chances_forest: Dictionary = GameParameters.CHANCES_FOREST
var chances_mountain: Dictionary = GameParameters.CHANCES_MOUNTAIN
var chances_village: Dictionary = GameParameters.CHANCES_VILLAGE

var battlefield_width: int = GameParameters.BATTLEFIELD_WIDTH
var battlefield_height: int = GameParameters.BATTLEFIELD_HEIGHT

var castle_start_height: int = GameParameters.CASTLE_START_HEIGHT

# gaming values
var castle_health: int = GameParameters.CASTLE_HEALTH
var start_gold: int = GameParameters.START_GOLD
var basic_income: int = GameParameters.BASIC_INCOME

var message_show_time: int = GameParameters.MESSAGE_SHOW_TIME
var round_time: int = GameParameters.ROUND_TIME
var queue_size: int = GameParameters.QUEUE_SIZE
var animation_speed_per_field: float = GameParameters.ANIMATION_SPEED_PER_FIELD
var animation_tolerance: float = GameParameters.ANIMATION_TOLERANCE

var income_per_factory: int = GameParameters.INCOME_PER_FACTORY
var factory_activation_time: int = GameParameters.FACTORY_ACTIVATION_TIME
var buildpoints_per_round: int = GameParameters.BUILDPOINTS_PER_ROUND
var max_food_amount: int = GameParameters.MAX_FOOD_AMOUNT

var damge_per_health: bool = GameParameters.DAMGE_PER_HEALTH
