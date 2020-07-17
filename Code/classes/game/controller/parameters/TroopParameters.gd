extends Node

const TROOP_NAME: Dictionary = { 
	TroopType.SWORDSMAN : "Swordsman", 
	TroopType.SPEARMAN : "Spearman",
	TroopType.ARCHER : "Archer",
	TroopType.KNIGHT : "Knight",
	TroopType.CATAPULT : "Catapult",
	TroopType.BATTLEAXFIGHTER : "Battleaxfighter",
	TroopType.CAVALARY : "Cavalary",
	TroopType.CROSSBOWMAN :"Crossbowman",
	TroopType.DOUBLEAXFIGHTER : "Doubleaxfighter",
	TroopType.HALBERDIER : "Halberdier",
	TroopType.SHORTSWORDSMAN : "Shortswordsman",
	TroopType.TREBUCHET : "Trebuchet",
	TroopType.CASTLE : "Castle"
}

const PRICE: Dictionary = { 
	TroopType.SWORDSMAN : 30, 
	TroopType.SPEARMAN : 15,
	TroopType.ARCHER : 20,
	TroopType.KNIGHT : 45,
	TroopType.CATAPULT : 20,
	TroopType.BATTLEAXFIGHTER : 30,
	TroopType.CAVALARY : 35,
	TroopType.CROSSBOWMAN :30,
	TroopType.DOUBLEAXFIGHTER : 20,
	TroopType.HALBERDIER : 25,
	TroopType.SHORTSWORDSMAN : 20,
	TroopType.TREBUCHET : 25
}

const BUILD_TIME: Dictionary = { 
	TroopType.SWORDSMAN : 1, 
	TroopType.SPEARMAN : 1,
	TroopType.ARCHER : 1,
	TroopType.KNIGHT : 2,
	TroopType.CATAPULT : 2,
	TroopType.BATTLEAXFIGHTER : 1,
	TroopType.CAVALARY : 2,
	TroopType.CROSSBOWMAN : 1,
	TroopType.DOUBLEAXFIGHTER : 1,
	TroopType.HALBERDIER : 1,
	TroopType.SHORTSWORDSMAN : 1,
	TroopType.TREBUCHET : 2
}

const SALARY: Dictionary = { 
	TroopType.SWORDSMAN : 4, 
	TroopType.SPEARMAN : 2,
	TroopType.ARCHER : 3,
	TroopType.KNIGHT : 6,
	TroopType.CATAPULT : 2,
	TroopType.BATTLEAXFIGHTER : 4,
	TroopType.CAVALARY : 4,
	TroopType.CROSSBOWMAN :4,
	TroopType.DOUBLEAXFIGHTER : 3,
	TroopType.HALBERDIER : 3,
	TroopType.SHORTSWORDSMAN : 3,
	TroopType.TREBUCHET : 3
}

const FPR: Dictionary = { 
	TroopType.SWORDSMAN : 4,
	TroopType.SPEARMAN : 6,
	TroopType.ARCHER : 6,
	TroopType.KNIGHT : 8,
	TroopType.CATAPULT : 5,
	TroopType.BATTLEAXFIGHTER : 4,
	TroopType.CAVALARY : 8,
	TroopType.CROSSBOWMAN :4,
	TroopType.DOUBLEAXFIGHTER : 6,
	TroopType.HALBERDIER : 4,
	TroopType.SHORTSWORDSMAN : 6,
	TroopType.TREBUCHET : 3
}

const START_HEALTH: Dictionary = {
	TroopType.SWORDSMAN : 375,
	TroopType.SPEARMAN : 125,
	TroopType.ARCHER : 100,
	TroopType.KNIGHT : 450,
	TroopType.CATAPULT : 15,
	TroopType.BATTLEAXFIGHTER : 375,
	TroopType.CAVALARY : 200,
	TroopType.CROSSBOWMAN : 275,
	TroopType.DOUBLEAXFIGHTER : 150,
	TroopType.HALBERDIER : 275,
	TroopType.SHORTSWORDSMAN : 150,
	TroopType.TREBUCHET : 350
}

const ATT_DMG: Dictionary = { 
	TroopType.SWORDSMAN : 20,
	TroopType.SPEARMAN : 15,
	TroopType.ARCHER : 40,
	TroopType.KNIGHT : 50,
	TroopType.CATAPULT : 15,
	TroopType.BATTLEAXFIGHTER : 40,
	TroopType.CAVALARY : 45,
	TroopType.CROSSBOWMAN : 40,
	TroopType.DOUBLEAXFIGHTER : 40,
	TroopType.HALBERDIER : 20,
	TroopType.SHORTSWORDSMAN : 20,
	TroopType.TREBUCHET : 25
}

const DEF_DMG: Dictionary = { 
	TroopType.SWORDSMAN : 40,
	TroopType.SPEARMAN : 20,
	TroopType.ARCHER : 30,
	TroopType.KNIGHT : 25,
	TroopType.CATAPULT : 10,
	TroopType.BATTLEAXFIGHTER : 20,
	TroopType.CAVALARY : 20,
	TroopType.CROSSBOWMAN : 40,
	TroopType.DOUBLEAXFIGHTER : 20,
	TroopType.HALBERDIER : 30,
	TroopType.SHORTSWORDSMAN : 40,
	TroopType.TREBUCHET : 10
}

const SPECIAL_DMG: Dictionary = { 
	TroopType.SWORDSMAN : { TroopType.SPEARMAN : 16, TroopType.HALBERDIER : 16 },
	TroopType.SPEARMAN : { TroopType.KNIGHT : 8, TroopType.CAVALARY : 8 },
	TroopType.ARCHER : { TroopType.CAVALARY : 5, TroopType.SPEARMAN : 5, TroopType.ARCHER : 5, TroopType.DOUBLEAXFIGHTER : 5, TroopType.SHORTSWORDSMAN : 5 },
	TroopType.KNIGHT : { TroopType.SWORDSMAN : 24, TroopType.SHORTSWORDSMAN : 24 },
	TroopType.CATAPULT : { TroopType.CASTLE : 15},
	TroopType.BATTLEAXFIGHTER : { TroopType.KNIGHT : 7, TroopType.HALBERDIER : 7, TroopType.CROSSBOWMAN : 7, TroopType.BATTLEAXFIGHTER : 7, TroopType.SWORDSMAN : 7 },
	TroopType.CAVALARY : { TroopType.SWORDSMAN : 16, TroopType.SHORTSWORDSMAN : 16 },
	TroopType.CROSSBOWMAN : { TroopType.CAVALARY : 7, TroopType.SPEARMAN : 7, TroopType.ARCHER : 7, TroopType.DOUBLEAXFIGHTER : 7, TroopType.SHORTSWORDSMAN : 7 },
	TroopType.DOUBLEAXFIGHTER : { TroopType.KNIGHT : 5, TroopType.HALBERDIER : 5, TroopType.CROSSBOWMAN : 5, TroopType.BATTLEAXFIGHTER : 5, TroopType.SWORDSMAN : 5 },
	TroopType.HALBERDIER : { TroopType.KNIGHT : 12, TroopType.CAVALARY : 12 },
	TroopType.SHORTSWORDSMAN : { TroopType.SPEARMAN : 12, TroopType.HALBERDIER : 12 },
	TroopType.TREBUCHET : { TroopType.CASTLE : 25}
}

const FIELD_ATT_DMG: Dictionary = { 
	TroopType.SWORDSMAN : { FieldType.CASTLE : -16, FieldType.MOUNTAIN : -8, FieldType.VILLAGE: 16 },
	TroopType.SPEARMAN : { FieldType.CASTLE : -8, FieldType.MOUNTAIN : 12 },
	TroopType.ARCHER : { FieldType.CASTLE : -12, FieldType.MOUNTAIN : -6, FieldType.VILLAGE: 12  },
	TroopType.KNIGHT : { FieldType.CASTLE : -24, FieldType.MOUNTAIN : -12, FieldType.GRASS: 48  },
	TroopType.CATAPULT : { FieldType.CASTLE : 0, FieldType.MOUNTAIN : -4 },
	TroopType.BATTLEAXFIGHTER : { FieldType.CASTLE : -16, FieldType.MOUNTAIN : -8, FieldType.VILLAGE: 32  },
	TroopType.CAVALARY : { FieldType.CASTLE : -16, FieldType.MOUNTAIN : -8, FieldType.GRASS: 16  },
	TroopType.CROSSBOWMAN : { FieldType.CASTLE : -16, FieldType.MOUNTAIN : -8 },
	TroopType.DOUBLEAXFIGHTER : { FieldType.CASTLE : -12, FieldType.MOUNTAIN : -6, FieldType.FOREST: 12 },
	TroopType.HALBERDIER : { FieldType.CASTLE : -12, FieldType.MOUNTAIN : 6 },
	TroopType.SHORTSWORDSMAN : { FieldType.CASTLE : -12, FieldType.MOUNTAIN : -6, FieldType.VILLAGE: 12, FieldType.FOREST: 12 },
	TroopType.TREBUCHET : { FieldType.CASTLE : 0, FieldType.MOUNTAIN : -6 }
}

const FIELD_DEF_DMG: Dictionary = { 
	TroopType.SWORDSMAN : { FieldType.CASTLE : 16, FieldType.MOUNTAIN : 8, FieldType.VILLAGE: 16 },
	TroopType.SPEARMAN : { FieldType.CASTLE : 8, FieldType.MOUNTAIN : 4 },
	TroopType.ARCHER : { FieldType.CASTLE : 12, FieldType.MOUNTAIN : 6, FieldType.FOREST: 12  },
	TroopType.KNIGHT : { FieldType.CASTLE : 24, FieldType.MOUNTAIN : 12 },
	TroopType.CATAPULT : { FieldType.CASTLE : 8, FieldType.MOUNTAIN : 4 },
	TroopType.BATTLEAXFIGHTER : { FieldType.CASTLE : 16, FieldType.MOUNTAIN : 8 },
	TroopType.CAVALARY : { FieldType.CASTLE : 16, FieldType.MOUNTAIN : 8, FieldType.GRASS: 16  },
	TroopType.CROSSBOWMAN : { FieldType.CASTLE : 16, FieldType.MOUNTAIN : 8, FieldType.VILLAGE : 32 },
	TroopType.DOUBLEAXFIGHTER : { FieldType.CASTLE : 12, FieldType.MOUNTAIN : 6, FieldType.FOREST: 12 },
	TroopType.HALBERDIER : { FieldType.CASTLE : 12, FieldType.MOUNTAIN : 6, FieldType.GRASS : 12 },
	TroopType.SHORTSWORDSMAN : { FieldType.CASTLE : 12, FieldType.MOUNTAIN : 6 },
	TroopType.TREBUCHET : { FieldType.CASTLE : 12, FieldType.MOUNTAIN : 6 }
}

const SCENE_BLUE: Dictionary = { 
	TroopType.SWORDSMAN : "res://classes/game/model/troops/BlueSwordsmanTroop.tscn", 
	TroopType.SPEARMAN : "res://classes/game/model/troops/BlueSpearmanTroop.tscn",
	TroopType.ARCHER : "res://classes/game/model/troops/BlueArcherTroop.tscn",
	TroopType.KNIGHT : "res://classes/game/model/troops/BlueKnightTroop.tscn",
	TroopType.CATAPULT : "res://classes/game/model/troops/BlueCatapultTroop.tscn",
	TroopType.BATTLEAXFIGHTER : "res://classes/game/model/troops/BlueBattleaxfighterTroop.tscn",
	TroopType.CAVALARY : "res://classes/game/model/troops/BlueCavalaryTroop.tscn",
	TroopType.CROSSBOWMAN : "res://classes/game/model/troops/BlueCrossbowmanTroop.tscn",
	TroopType.DOUBLEAXFIGHTER : "res://classes/game/model/troops/BlueDoubleaxfighterTroop.tscn",
	TroopType.HALBERDIER : "res://classes/game/model/troops/BlueHalberdierTroop.tscn",
	TroopType.SHORTSWORDSMAN : "res://classes/game/model/troops/BlueShortswodsmanTroop.tscn",
	TroopType.TREBUCHET : "res://classes/game/model/troops/BlueTrebuchetTroop.tscn"
}

const SCENE_RED: Dictionary = { 
	TroopType.SWORDSMAN : "res://classes/game/model/troops/RedSwordsmanTroop.tscn", 
	TroopType.SPEARMAN : "res://classes/game/model/troops/RedSpearmanTroop.tscn",
	TroopType.ARCHER : "res://classes/game/model/troops/RedArcherTroop.tscn",
	TroopType.KNIGHT : "res://classes/game/model/troops/RedKnightTroop.tscn",
	TroopType.CATAPULT : "res://classes/game/model/troops/RedCatapultTroop.tscn",
	TroopType.BATTLEAXFIGHTER : "res://classes/game/model/troops/RedBattleaxfighterTroop.tscn",
	TroopType.CAVALARY : "res://classes/game/model/troops/RedCavalaryTroop.tscn",
	TroopType.CROSSBOWMAN : "res://classes/game/model/troops/RedCrossbowmanTroop.tscn",
	TroopType.DOUBLEAXFIGHTER : "res://classes/game/model/troops/RedDoubleaxfighterTroop.tscn",
	TroopType.HALBERDIER : "res://classes/game/model/troops/RedHalberdierTroop.tscn",
	TroopType.SHORTSWORDSMAN : "res://classes/game/model/troops/RedShortswodsmanTroop.tscn",
	TroopType.TREBUCHET : "res://classes/game/model/troops/RedTrebuchetTroop.tscn"
}

const SCENE_QUEUE: Dictionary = { 
	TroopType.SWORDSMAN : "res://classes/game/view/buttons/queue/SwordsmanQueueButton.tscn", 
	TroopType.SPEARMAN : "res://classes/game/view/buttons/queue/SpearmanQueueButton.tscn",
	TroopType.ARCHER : "res://classes/game/view/buttons/queue/ArcherQueueButton.tscn",
	TroopType.KNIGHT : "res://classes/game/view/buttons/queue/KnightQueueButton.tscn",
	TroopType.CATAPULT : "res://classes/game/view/buttons/queue/CatapultQueueButton.tscn",
	TroopType.BATTLEAXFIGHTER : "res://classes/game/view/buttons/queue/BattleaxfighterQueueButton.tscn",
	TroopType.CAVALARY : "res://classes/game/view/buttons/queue/CavalaryQueueButton.tscn",
	TroopType.CROSSBOWMAN : "res://classes/game/view/buttons/queue/CrossbowmanQueueButton.tscn",
	TroopType.DOUBLEAXFIGHTER : "res://classes/game/view/buttons/queue/DoubleaxfighterQueueButton.tscn",
	TroopType.HALBERDIER : "res://classes/game/view/buttons/queue/HalberdierQueueButton.tscn",
	TroopType.SHORTSWORDSMAN : "res://classes/game/view/buttons/queue/ShortswordsmanQueueButton.tscn",
	TroopType.TREBUCHET : "res://classes/game/view/buttons/queue/TrebuchetQueueButton.tscn",
}
