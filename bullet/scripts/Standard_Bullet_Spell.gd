extends Node

class_name Standard_Bullet_Spell

var Standard_Bullet = preload("res://scenes/e1_bullet.tscn")

func _ready():
	pass


func cast(global_pos: Vector2, shoot_v: Vector2, acc = 0):
	var bullet = Standard_Bullet.instance()
	bullet.init(shoot_v, acc)
	bullet.global_position = global_pos
	return bullet
