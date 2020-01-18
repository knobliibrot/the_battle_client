extends Node

class_name Player

var player_name: String
var player_type: int
var castle_health: int
var gold: int
var income: int
var salary: int
var troops: Array
var queue: Array

func init(type: int) -> void:
	self.player_name = "Player"
	self.player_type = type
	self.castle_health = GameParameters.DEFAULT_CASTLE_HEALTH
	self.gold = GameParameters.DEFAULT_START_GOLD
	self.income = GameParameters.DEFAULT_BASIC_INCOME
	self.salary = 0
	