extends Node

class_name TroopType

const PRICE = { 
TroopTypeEnum.SWORDSMAN : 10, 
TroopTypeEnum.SPEARMAN : 7,
TroopTypeEnum.ARCHER : 10,
TroopTypeEnum.KNIGHT : 25,
TroopTypeEnum.CATAPULT : 10
}

const BUILD_TIME = { 
TroopTypeEnum.SWORDSMAN : 1, 
TroopTypeEnum.SPEARMAN : 1,
TroopTypeEnum.ARCHER : 1,
TroopTypeEnum.KNIGHT : 2,
TroopTypeEnum.CATAPULT : 2
}

const SALARY = { 
TroopTypeEnum.SWORDSMAN : 3, 
TroopTypeEnum.SPEARMAN : 2,
TroopTypeEnum.ARCHER : 3,
TroopTypeEnum.KNIGHT : 6,
TroopTypeEnum.CATAPULT : 2
}

const FPR = { 
TroopTypeEnum.SWORDSMAN : 4,
TroopTypeEnum.SPEARMAN : 5,
TroopTypeEnum.ARCHER : 5,
TroopTypeEnum.KNIGHT : 8,
TroopTypeEnum.CATAPULT : 2
}

const START_HEALTH = { 
TroopTypeEnum.SWORDSMAN : 40,
TroopTypeEnum.SPEARMAN : 30,
TroopTypeEnum.ARCHER : 20,
TroopTypeEnum.KNIGHT : 100,
TroopTypeEnum.CATAPULT : 60
}

const ATTACK_DMG = { 
TroopTypeEnum.SWORDSMAN : 10,
TroopTypeEnum.SPEARMAN : 8,
TroopTypeEnum.ARCHER : 20,
TroopTypeEnum.KNIGHT : 25,
TroopTypeEnum.CATAPULT : 5
}

const DEFFENCE_DMG = { 
TroopTypeEnum.SWORDSMAN : 15,
TroopTypeEnum.SPEARMAN : 10,
TroopTypeEnum.ARCHER : 30,
TroopTypeEnum.KNIGHT : 15,
TroopTypeEnum.CATAPULT : 10
}

const SPECIAL_DMG = { 
TroopTypeEnum.SWORDSMAN : { TroopTypeEnum.SPEARMAN : 1.3 },
TroopTypeEnum.SPEARMAN : { TroopTypeEnum.KNIGHT : 2.5 },
TroopTypeEnum.ARCHER : {},
TroopTypeEnum.KNIGHT : {},
TroopTypeEnum.CATAPULT : {}
}

const SCENE_BLUE = { 
TroopTypeEnum.SWORDSMAN : "res://classes/game/view/troops/BlueSwordsmanTroop.tscn", 
TroopTypeEnum.SPEARMAN : "res://classes/game/view/troops/BlueSpearmanTroop.tscn",
TroopTypeEnum.ARCHER : "res://classes/game/view/troops/BlueArcherTroop.tscn",
TroopTypeEnum.KNIGHT : "res://classes/game/view/troops/BlueKnightTroop.tscn",
TroopTypeEnum.CATAPULT : "res://classes/game/view/troops/BlueCatapultTroop.tscn"
}

const SCENE_RED = { 
TroopTypeEnum.SWORDSMAN : "res://classes/game/view/troops/RedSwordsmanTroop.tscn", 
TroopTypeEnum.SPEARMAN : "res://classes/game/view/troops/RedSpearmanTroop.tscn",
TroopTypeEnum.ARCHER : "res://classes/game/view/troops/RedArcherTroop.tscn",
TroopTypeEnum.KNIGHT : "res://classes/game/view/troops/RedKnightTroop.tscn",
TroopTypeEnum.CATAPULT : "res://classes/game/view/troops/RedCatapultTroop.tscn"
}

const SCENE_QUEUE = { 
TroopTypeEnum.SWORDSMAN : "res://classes/game/view/buttons/queue/SwordsmanQueueButton.tscn", 
TroopTypeEnum.SPEARMAN : "res://classes/game/view/buttons/queue/SpearmanQueueButton.tscn",
TroopTypeEnum.ARCHER : "res://classes/game/view/buttons/queue/ArcherQueueButton.tscn",
TroopTypeEnum.KNIGHT : "res://classes/game/view/buttons/queue/KnightQueueButton.tscn",
TroopTypeEnum.CATAPULT : "res://classes/game/view/buttons/queue/CatapultQueueButton.tscn"
}