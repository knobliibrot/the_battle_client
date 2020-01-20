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