extends Node

# Battelfield Generation Parameters
const CHANCES_GRASS: Dictionary =  {
	FieldType.GRASS: {
		1 : 15,
		2 : 25,
		3 : 50
	},
	FieldType.FOREST: {
		1 : 6,
		2 : 23,
		3 : 16 
	},
	FieldType.MOUNTAIN: {
		1 : 6,
		2 : 6,
		3 : 16 
	},
	FieldType.VILLAGE: {
		1 : 4,
		2 : 5,
		3 : 9
	}
}

const CHANCES_FOREST: Dictionary =  {
	FieldType.GRASS: {
		1 : 8,
		2 : 12,
		3 : 21 
	},
	FieldType.FOREST: {
		1 : 8,
		2 : 25,
		3 : 45
	},
	FieldType.MOUNTAIN: {
		1 : 6,
		2 : 6,
		3 : 12 
	},
	FieldType.VILLAGE: {
		1 : 4,
		2 : 5,
		3 : 9
	}
}

const CHANCES_MOUNTAIN: Dictionary =  {
	FieldType.GRASS: {
		1 : 8,
		2 : 12,
		3 : 21 
	},
	FieldType.FOREST: {
		1 : 6,
		2 : 6,
		3 : 12 
	},
	FieldType.MOUNTAIN: {
		1 : 10,
		2 : 15,
		3 : 20 
	},
	FieldType.VILLAGE: {
		1 : 4,
		2 : 5,
		3 : 9
	}
}

const CHANCES_VILLAGE: Dictionary =  {
	FieldType.GRASS: {
		1 : 8,
		2 : 12,
		3 : 21 
	},
	FieldType.FOREST: {
		1 : 6,
		2 : 6,
		3 : 12 
	},
	FieldType.MOUNTAIN: {
		1 : 6,
		2 : 6,
		3 : 12 
	},
	FieldType.VILLAGE: {
		1 : 8,
		2 : 8,
		3 : 15
	}
}

const START_GRASS_CHANCE: int = 40
const START_OTHER_CHANCE: int = 20

const BATTLEFIELD_WIDTH: int = 21
const BATTLEFIELD_HEIGHT: int = 7

const MOVEMENT_X: int = 40
const MOVEMENT_Y: int = 69

const CASTLE_START_HEIGHT: int = 3

# Gaming Values
const CASTLE_HEALTH: int = 150
const START_GOLD: int = 100
const BASIC_INCOME: int = 15
const INCOME_PER_FACTORY: int = 5
const FACTORY_ACTIVATION_TIME: int = 2
const MAX_FOOD_AMOUNT: int = 3

const ROUND_TIME: int = 25
const INITIAL_ROUND_TIME = 75
const QUEUE_SIZE: int = 4
const BUILDPOINTS_PER_ROUND: int = 2

const ANIMATION_SPEED_PER_FIELD: float = 0.1
const ANIMATION_TOLERANCE: float = 5.0

const DAMGE_PER_HEALTH: bool = false

const STANDARD_TROOPS: Array = [
	TroopType.SPEARMAN,
	TroopType.SWORDSMAN,
	TroopType.KNIGHT,
	TroopType.ARCHER,
	TroopType.CATAPULT
	]
