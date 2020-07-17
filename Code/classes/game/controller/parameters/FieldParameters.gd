extends Node

const FIELD_NAME: Dictionary = {
	FieldType.CASTLE : "Castle",
	FieldType.GRASS : "Grass",
	FieldType.MOUNTAIN : "Mountain",
	FieldType.VILLAGE : "Village",
	FieldType.FOREST : "Forest"
}
const CONNECTION_PAIRS: Dictionary = {
	FieldConnectionType.LEFT : FieldConnectionType.RIGHT,
	FieldConnectionType.RIGHT : FieldConnectionType.LEFT,
	FieldConnectionType.LEFT_DOWN : FieldConnectionType.RIGHT_UP,
	FieldConnectionType.LEFT_UP : FieldConnectionType.RIGHT_DOWN,
	FieldConnectionType.RIGHT_DOWN : FieldConnectionType.LEFT_UP,
	FieldConnectionType.RIGHT_UP : FieldConnectionType.LEFT_DOWN
}

const SPEED: Dictionary = {
	FieldType.CASTLE : 3,
	FieldType.GRASS : 1,
	FieldType.MOUNTAIN : 5,
	FieldType.VILLAGE : 2,
	FieldType.FOREST : 2
}

const ATT_DMG: Dictionary = {
	FieldType.CASTLE : {
		TroopType.SWORDSMAN: 0.5,
		TroopType.SPEARMAN: 0.5,
		TroopType.ARCHER: 0.5,
		TroopType.KNIGHT: 0.5,
		TroopType.CATAPULT: 4
	},
	FieldType.GRASS : {
		TroopType.SWORDSMAN: 1,
		TroopType.SPEARMAN: 1,
		TroopType.ARCHER: 1,
		TroopType.KNIGHT: 1.5,
		TroopType.CATAPULT: 1
		},
	FieldType.MOUNTAIN : {
		TroopType.SWORDSMAN: 0.666,
		TroopType.SPEARMAN: 2,
		TroopType.ARCHER: 0.666,
		TroopType.KNIGHT: 0.666,
		TroopType.CATAPULT: 0.666
		},
	FieldType.VILLAGE : {
		TroopType.SWORDSMAN: 1.5,
		TroopType.SPEARMAN: 1,
		TroopType.ARCHER: 1.5,
		TroopType.KNIGHT: 1,
		TroopType.CATAPULT: 1.5
		},
	FieldType.FOREST : {
		TroopType.SWORDSMAN: 1,
		TroopType.SPEARMAN: 1.5,
		TroopType.ARCHER: 1,
		TroopType.KNIGHT: 1,
		TroopType.CATAPULT: 1
		}
}

const DEF_DMG: Dictionary = {
	FieldType.CASTLE : {
		TroopType.SWORDSMAN: 1.5,
		TroopType.SPEARMAN: 1.5,
		TroopType.ARCHER: 1.5,
		TroopType.KNIGHT: 1.5,
		TroopType.CATAPULT: 1.5
	},
	FieldType.GRASS : {
		TroopType.SWORDSMAN: 1,
		TroopType.SPEARMAN: 1.5,
		TroopType.ARCHER: 1,
		TroopType.KNIGHT: 1.5,
		TroopType.CATAPULT: 1
	},
	FieldType.MOUNTAIN : {
		TroopType.SWORDSMAN: 1.333,
		TroopType.SPEARMAN: 2,
		TroopType.ARCHER: 1.333,
		TroopType.KNIGHT: 1.333,
		TroopType.CATAPULT: 1.333
	},
	FieldType.VILLAGE : {
		TroopType.SWORDSMAN: 1.5,
		TroopType.SPEARMAN: 1,
		TroopType.ARCHER: 1,
		TroopType.KNIGHT: 1,
		TroopType.CATAPULT: 1
		},
	FieldType.FOREST : {
		TroopType.SWORDSMAN: 1,
		TroopType.SPEARMAN: 1,
		TroopType.ARCHER: 1.5,
		TroopType.KNIGHT: 1,
		TroopType.CATAPULT: 1
		}
}
