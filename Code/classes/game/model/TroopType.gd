extends Node

class_name TroopType

const PRICE = { 
TroopTypeEnum.SWORDSMAN : 10, 
TroopTypeEnum.SPEARMAN : 7,
TroopTypeEnum.ARCHER : 10,
TroopTypeEnum.KNIGHT : 25,
TroopTypeEnum.CATAPULT : 10
}

const SCENE_BLUE = { 
TroopTypeEnum.SWORDSMAN : "res://classes/game/view/troops/BlueSwordsmannTroop.tscn", 
TroopTypeEnum.SPEARMAN : "res://classes/game/view/troops/BlueSpearmanTroop.tscn",
TroopTypeEnum.ARCHER : "res://classes/game/view/troops/BlueArcherTroop.tscn",
TroopTypeEnum.KNIGHT : "res://classes/game/view/troops/BlueKnightTroop.tscn",
TroopTypeEnum.CATAPULT : "res://classes/game/view/troops/BlueCatapultTroop.tscn"
}

const SCENE_RED = { 
TroopTypeEnum.SWORDSMAN : "res://classes/game/view/troops/RedSwordsmannTroop.tscn", 
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