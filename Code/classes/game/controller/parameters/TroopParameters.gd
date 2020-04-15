extends Node

const PRICE: Dictionary = { 
	TroopType.SWORDSMAN : 20, 
	TroopType.SPEARMAN : 15,
	TroopType.ARCHER : 20,
	TroopType.KNIGHT : 40,
	TroopType.CATAPULT : 25
}

const BUILD_TIME: Dictionary = { 
	TroopType.SWORDSMAN : 1, 
	TroopType.SPEARMAN : 1,
	TroopType.ARCHER : 1,
	TroopType.KNIGHT : 2,
	TroopType.CATAPULT : 2
}

const SALARY: Dictionary = { 
	TroopType.SWORDSMAN : 2, 
	TroopType.SPEARMAN : 1,
	TroopType.ARCHER : 2,
	TroopType.KNIGHT : 4,
	TroopType.CATAPULT : 2
}

const FPR: Dictionary = { 
	TroopType.SWORDSMAN : 4,
	TroopType.SPEARMAN : 6,
	TroopType.ARCHER : 6,
	TroopType.KNIGHT : 8,
	TroopType.CATAPULT : 3
}

const START_HEALTH: Dictionary = {
	TroopType.SWORDSMAN : 80,
	TroopType.SPEARMAN : 60,
	TroopType.ARCHER : 50,
	TroopType.KNIGHT : 150,
	TroopType.CATAPULT : 80
}

const ATT_DMG: Dictionary = { 
	TroopType.SWORDSMAN : 22,
	TroopType.SPEARMAN : 15,
	TroopType.ARCHER : 20,
	TroopType.KNIGHT : 30,
	TroopType.CATAPULT : 15
}

const DEF_DMG: Dictionary = { 
	TroopType.SWORDSMAN : 15,
	TroopType.SPEARMAN : 15,
	TroopType.ARCHER : 30,
	TroopType.KNIGHT : 20,
	TroopType.CATAPULT : 25
}

const SPECIAL_DMG: Dictionary = { 
	TroopType.SWORDSMAN : { TroopType.ARCHER : 1.5 },
	TroopType.SPEARMAN : { TroopType.KNIGHT : 2.5 },
	TroopType.ARCHER : { TroopType.SPEARMAN : 1.5 },
	TroopType.KNIGHT : { TroopType.SWORDSMAN : 1.5 },
	TroopType.CATAPULT : { TroopType.CASTLE : 6}
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
