class_name EnemyFactory
extends Node

var Tp_Circle = preload("res://scenes/extra_animation/circle.tscn")
var Shooting_Enemy = preload("res://scenes/e1.tscn")
var Speedster_Enemy = preload("res://scenes/e2.tscn")
var MAI = preload("res://scenes/MagoAzulInicio.tscn")
func _ready():
	return
	
func new_shooting_enemy(x, y):
	var new_enemy = Shooting_Enemy.instance()
	new_enemy.global_position = Vector2(x, y)
	return new_enemy
	
func new_speedster_enemy(x, y):
	var new_enemy = Speedster_Enemy.instance()
	new_enemy.global_position = Vector2(x, y)
	return new_enemy

func new_mago_inicio(x, y): #npcs?
	var mai = MAI.instance()
	mai.global_position = Vector2(x, y)
	return mai

func new_tp_circle(): #animation?
	var circle = Tp_Circle.instance()
	return circle
