extends Node

const PRICE: Dictionary = { 
	TroopType.SWORDSMAN : 10, 
	TroopType.SPEARMAN : 7,
	TroopType.ARCHER : 10,
	TroopType.KNIGHT : 25,
	TroopType.CATAPULT : 10
}

const BUILD_TIME: Dictionary = { 
	TroopType.SWORDSMAN : 1, 
	TroopType.SPEARMAN : 1,
	TroopType.ARCHER : 1,
	TroopType.KNIGHT : 2,
	TroopType.CATAPULT : 2
}

const SALARY: Dictionary = { 
	TroopType.SWORDSMAN : 3, 
	TroopType.SPEARMAN : 2,
	TroopType.ARCHER : 3,
	TroopType.KNIGHT : 6,
	TroopType.CATAPULT : 2
}

const FPR: Dictionary = { 
	TroopType.SWORDSMAN : 4,
	TroopType.SPEARMAN : 5,
	TroopType.ARCHER : 5,
	TroopType.KNIGHT : 8,
	TroopType.CATAPULT : 2
}

const START_HEALTH: Dictionary = { 
	TroopType.SWORDSMAN : 40,
	TroopType.SPEARMAN : 30,
	TroopType.ARCHER : 20,
	TroopType.KNIGHT : 100,
	TroopType.CATAPULT : 60
}

const ATT_DMG: Dictionary = { 
	TroopType.SWORDSMAN : 10,
	TroopType.SPEARMAN : 8,
	TroopType.ARCHER : 20,
	TroopType.KNIGHT : 25,
	TroopType.CATAPULT : 5
}

const DEF_DMG: Dictionary = { 
	TroopType.SWORDSMAN : 15,
	TroopType.SPEARMAN : 10,
	TroopType.ARCHER : 30,
	TroopType.KNIGHT : 15,
	TroopType.CATAPULT : 10
}

const SPECIAL_DMG: Dictionary = { 
	TroopType.SWORDSMAN : { TroopType.SPEARMAN : 1.3 },
	TroopType.SPEARMAN : { TroopType.KNIGHT : 2.5 },
	TroopType.ARCHER : {},
	TroopType.KNIGHT : {},
	TroopType.CATAPULT : { TroopType.CASTLE : 20}
}

const SCENE_BLUE: Dictionary = { 
	TroopType.SWORDSMAN : "res://classes/game/model/troops/BlueSwordsmanTroop.tscn", 
	TroopType.SPEARMAN : "res://classes/game/model/troops/BlueSpearmanTroop.tscn",
	TroopType.ARCHER : "res://classes/game/model/troops/BlueArcherTroop.tscn",
	TroopType.KNIGHT : "res://classes/game/model/troops/BlueKnightTroop.tscn",
	TroopType.CATAPULT : "res://classes/game/model/troops/BlueCatapultTroop.tscn"
}

const SCENE_RED: Dictionary = { 
	TroopType.SWORDSMAN : "res://classes/game/model/troops/RedSwordsmanTroop.tscn", 
	TroopType.SPEARMAN : "res://classes/game/model/troops/RedSpearmanTroop.tscn",
	TroopType.ARCHER : "res://classes/game/model/troops/RedArcherTroop.tscn",
	TroopType.KNIGHT : "res://classes/game/model/troops/RedKnightTroop.tscn",
	TroopType.CATAPULT : "res://classes/game/model/troops/RedCatapultTroop.tscn"
}

const SCENE_QUEUE: Dictionary = { 
	TroopType.SWORDSMAN : "res://classes/game/view/buttons/queue/SwordsmanQueueButton.tscn", 
	TroopType.SPEARMAN : "res://classes/game/view/buttons/queue/SpearmanQueueButton.tscn",
	TroopType.ARCHER : "res://classes/game/view/buttons/queue/ArcherQueueButton.tscn",
	TroopType.KNIGHT : "res://classes/game/view/buttons/queue/KnightQueueButton.tscn",
	TroopType.CATAPULT : "res://classes/game/view/buttons/queue/CatapultQueueButton.tscn"
}
