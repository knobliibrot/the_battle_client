extends Node

signal castle_choosen

const FieldTypeEnum = preload("res://classes/enums/FieldTypeEnum.gd")
const Parameters = preload("res://classes/game/model/Rulebook/GameParameters.gd")

const GRASS_SCENE = "res://classes/game/view/fields/GrassFieldScene.tscn"
const FOREST_SCENE = "res://classes/game/view/fields/ForestFieldScene.tscn"
const MOUNTAIN_SCENE = "res://classes/game/view/fields/MountainFieldScene.tscn"
const VILLAGE_SCENE = "res://classes/game/view/fields/VillageFieldScene.tscn"
const CASTLE_SCENE = "res://classes/game/view/fields/CastleFieldScene.tscn"
const EMPTY_SCENE = "res://classes/game/view/fields/EmptyFieldScene.tscn"


func render_battlefield(var battlefield_map: Array):
	for y in range(Parameters.BATTLEFIELD_HEIGHT):
		for x in range(Parameters.BATTLEFIELD_WIDTH):
			if(x + y) % 2 == 1:
				var scene_path: String
				var new_node: FieldScene 
				if battlefield_map[y][x].get_field_type() == FieldTypeEnum.EMPTY:
					scene_path = EMPTY_SCENE
					new_node = load(scene_path).instance()
					new_node.set_disabled(true)
					print(x)
					if x == 0:
						new_node.add_to_group("castle_field_2")
						print(y)
					else:
						new_node.add_to_group("castle_field_1")
				else:
					if battlefield_map[y][x].get_field_type() == FieldTypeEnum.GRASS:
						scene_path = GRASS_SCENE
					elif battlefield_map[y][x].get_field_type() == FieldTypeEnum.FOREST:
						scene_path = FOREST_SCENE
					elif battlefield_map[y][x].get_field_type() == FieldTypeEnum.MOUNTAIN:
						scene_path = MOUNTAIN_SCENE
					elif battlefield_map[y][x].get_field_type() == FieldTypeEnum.VILLAGE:
						scene_path = VILLAGE_SCENE
						
					new_node = load(scene_path).instance()					

				var position_node: Node = get_node("BattelfieldMap/" +str(x) + "-" + str(y))
				new_node.field = battlefield_map[y][x]
				new_node.copy_data(position_node)
				new_node.connect("castle_choosen", self, "_on_Field_castle_choosen")
				position_node.replace_by(new_node,true)
				
func _on_Field_castle_choosen(position :Vector2) -> void:
	emit_signal("castle_choosen", position)
