extends Node

class_name EnemyFactory

var Shooting_Enemy = preload("res://scenes/e1.tscn")
var Speedster_Enemy = preload("res://scenes/e2.tscn")
var MAI = preload("res://scenes/MagoAzulInicio.tscn")

func _ready():
	pass
	
func new_shooting_enemy(x, y):
	var new_enemy = Shooting_Enemy.instance()
	new_enemy.global_position = Vector2(x, y)
	return new_enemy
	
func new_speedster_enemy(x, y):
	var new_enemy = Speedster_Enemy.instance()
	new_enemy.global_position = Vector2(x, y)
	return new_enemy

func new_mago_inicio(x, y): #npcs??
	var mai = MAI.instance()
	mai.global_position = Vector2(x, y)
	return mai
	
	
