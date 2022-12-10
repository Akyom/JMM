extends Node

var times = 0
var EnemyFactory = preload("res://scripts/enemy_factory.gd")
var Factory = EnemyFactory.new()
var enemies = []
var free_pos = []

func _ready():
	pass

func _process(_delta):
	if (times == 0):
		var enemy1 = Factory.new_shooting_enemy(-10, -10)
		var enemy2 = Factory.new_speedster_enemy(10, 10)
		var enemy3 = Factory.new_speedster_enemy(-10, 10)
		addEnemy(enemy1)
		addEnemy(enemy2)
		addEnemy(enemy3)
		times += 1

func addEnemy(enemy):
	if (free_pos.size() == 0):
		enemy.indx = enemies.size()
		enemies += [enemy]
	else:
		var pos = free_pos.pop()
		enemy.indx = pos
		enemies[pos] = enemy
	get_parent().add_child(enemy)
	
func enemy_died(enemy):
	if (enemy.indx != -1):
		enemies[enemy.indx] = null
		free_pos.append(enemy.indx)
	enemy.queue_free()
