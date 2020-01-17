extends Node

const FieldTypeEnum = preload("res://classes/enums/FieldTypeEnum.gd")

const GRASS_SCENE = "res://classes/game/view/fields/GrassFieldScene.tscn"
const FOREST_SCENE = "res://classes/game/view/fields/ForestFieldScene.tscn"
const MOUNTAIN_SCENE = "res://classes/game/view/fields/MountainFieldScene.tscn"
const VILLAGE_SCENE = "res://classes/game/view/fields/VillageFieldScene.tscn"
const CASTLE_SCENE = "res://classes/game/view/fields/CastleFieldScene.tscn"
const EMPTY_SCENE = "res://classes/game/view/fields/EmptyFieldScene.tscn"


func render_battlefield(var battlefield_map: Array):
	for y in range(7):
		for x in range(21):
			if(x + y) % 2 == 1:
				var scene_path: String
				if x == 0 or x == 20:
					scene_path = EMPTY_SCENE
				else:
					if battlefield_map[y][x].get_field_type() == FieldTypeEnum.GRASS:
						scene_path = GRASS_SCENE
					elif battlefield_map[y][x].get_field_type() == FieldTypeEnum.FOREST:
						scene_path = FOREST_SCENE
					elif battlefield_map[y][x].get_field_type() == FieldTypeEnum.MOUNTAIN:
						scene_path = MOUNTAIN_SCENE
					elif battlefield_map[y][x].get_field_type() == FieldTypeEnum.VILLAGE:
						scene_path = VILLAGE_SCENE

					var position_node: Node = get_node("BattelfieldMap/" +str(x) + "-" + str(y))

					var new_node: Node = load(scene_path) .instance()
					new_node.set_rect(position_node.get_rect())
					position_node.replace_by(new_node,true)
