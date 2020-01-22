extends Node

class_name FieldConnection

const PAIRS = { FieldConnectionTypeEnum.LEFT : FieldConnectionTypeEnum.RIGHT,
FieldConnectionTypeEnum.RIGHT : FieldConnectionTypeEnum.LEFT,
FieldConnectionTypeEnum.LEFT_DOWN : FieldConnectionTypeEnum.RIGHT_UP,
FieldConnectionTypeEnum.LEFT_UP : FieldConnectionTypeEnum.RIGHT_DOWN,
FieldConnectionTypeEnum.RIGHT_DOWN : FieldConnectionTypeEnum.LEFT_UP,
FieldConnectionTypeEnum.RIGHT_UP : FieldConnectionTypeEnum.LEFT_DOWN,}

const FIELD_SPEED = {
FieldTypeEnum.CASTLE : 2,
FieldTypeEnum.GRASS : 1,
FieldTypeEnum.MOUNTAIN :4,
FieldTypeEnum.VILLAGE :2,
FieldTypeEnum.FOREST :3}

const DAMAGE = {
	FieldTypeEnum.CASTLE : {
		TroopTypeEnum.SWORDSMAN: 0.5,
		TroopTypeEnum.SPEARMAN: 0.5,
		TroopTypeEnum.ARCHER: 0.5,
		TroopTypeEnum.KNIGHT: 0.5,
		TroopTypeEnum.CATAPULT: 0.5},
	FieldTypeEnum.GRASS : {TroopTypeEnum.KNIGHT: 1.5},
	FieldTypeEnum.MOUNTAIN :{},
	FieldTypeEnum.VILLAGE : {TroopTypeEnum.SWORDSMAN: 1.5},
	FieldTypeEnum.FOREST : {
		TroopTypeEnum.ARCHER: 1.5, 
		TroopTypeEnum.SPEARMAN: 1.5}}
		
const DEF_DAMAGE = {
	FieldTypeEnum.CASTLE : {
		TroopTypeEnum.SWORDSMAN: 3,
		TroopTypeEnum.SPEARMAN: 3,
		TroopTypeEnum.ARCHER: 3,
		TroopTypeEnum.KNIGHT: 3,
		TroopTypeEnum.CATAPULT: 3},
	FieldTypeEnum.GRASS : {},
	FieldTypeEnum.MOUNTAIN :{
		TroopTypeEnum.SWORDSMAN: 1.5,
		TroopTypeEnum.SPEARMAN: 1.5,
		TroopTypeEnum.ARCHER: 1.5,
		TroopTypeEnum.KNIGHT: 1.5,
		TroopTypeEnum.CATAPULT: 1.5},
	FieldTypeEnum.VILLAGE :{},
	FieldTypeEnum.FOREST : {}}