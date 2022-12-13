extends Node

var times = 0
var EnemyFactory = preload("res://scripts/enemy_factory.gd")
var Factory = EnemyFactory.new()
var enemies = []
var free_pos = []
var number_of_enemies = 1
func _ready():
	pass

func _process(_delta):
	if (times == 0):
		for x in range(-number_of_enemies/2, number_of_enemies/2):
			for y in range(-number_of_enemies/2, number_of_enemies/2):
				var enemy1 = Factory.new_shooting_enemy(0, 0)
				addEnemy(enemy1)
		var enemy = Factory.new_shooting_enemy(0, 0)
		addEnemy(enemy)
		times += 1
		var enemy2 = Factory.new_shooting_enemy(0.00001, 0.00001)
		addEnemy(enemy2)

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
