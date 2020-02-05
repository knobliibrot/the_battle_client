extends Node

const CONNECTION_PAIRS: Dictionary = {
	FieldConnectionType.LEFT : FieldConnectionType.RIGHT,
	FieldConnectionType.RIGHT : FieldConnectionType.LEFT,
	FieldConnectionType.LEFT_DOWN : FieldConnectionType.RIGHT_UP,
	FieldConnectionType.LEFT_UP : FieldConnectionType.RIGHT_DOWN,
	FieldConnectionType.RIGHT_DOWN : FieldConnectionType.LEFT_UP,
	FieldConnectionType.RIGHT_UP : FieldConnectionType.LEFT_DOWN
}

const SPEED: Dictionary = {
	FieldType.CASTLE : 2,
	FieldType.GRASS : 1,
	FieldType.MOUNTAIN : 4,
	FieldType.VILLAGE : 2,
	FieldType.FOREST : 3
}

const ATT_DMG: Dictionary = {
	FieldType.CASTLE : {
		TroopType.SWORDSMAN: 0.5,
		TroopType.SPEARMAN: 0.5,
		TroopType.ARCHER: 0.5,
		TroopType.KNIGHT: 0.5,
		TroopType.CATAPULT: 0.5
	},
	FieldType.GRASS : {TroopType.KNIGHT: 1.5},
	FieldType.MOUNTAIN : {},
	FieldType.VILLAGE : {TroopType.SWORDSMAN: 1.5},
	FieldType.FOREST : {
		TroopType.ARCHER: 1.5, 
		TroopType.SPEARMAN: 1.5
	}
}
		
const DEF_DMG: Dictionary = {
	FieldType.CASTLE : {
		TroopType.SWORDSMAN: 3,
		TroopType.SPEARMAN: 3,
		TroopType.ARCHER: 3,
		TroopType.KNIGHT: 3,
		TroopType.CATAPULT: 3
	},
	FieldType.GRASS : {},
	FieldType.MOUNTAIN : {
		TroopType.SWORDSMAN: 1.5,
		TroopType.SPEARMAN: 1.5,
		TroopType.ARCHER: 1.5,
		TroopType.KNIGHT: 1.5,
		TroopType.CATAPULT: 1.5
	},
	FieldType.VILLAGE : {},
	FieldType.FOREST : {}
}
