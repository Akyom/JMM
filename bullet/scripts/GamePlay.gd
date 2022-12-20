extends Node

var times = 0
var EnemyFactory = preload("res://scripts/enemy_factory.gd")
var Factory = EnemyFactory.new()
var enemies = []
var free_pos = []
var number_of_enemies = 1
var fight = false


func _process(_delta):
	if times == 0:
		var mai = Factory.new_mago_inicio(0, -100)
		addNPC(mai)
		times = times + 1
	if fight:
		oleada()
		times = times + 1
		fight = false

func addNPC(npc): #que mas?
	get_parent().add_child(npc)
	
func removeNPC(npc): #que mas?
	npc.queue_free()

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

func npc_action(npc):
	npc.player_input()

func start_fight():
	fight = true
	
func oleada():
	if times == 1:
		var enemy1 = Factory.new_shooting_enemy(-50, -150)
		var enemy2 = Factory.new_shooting_enemy(0, -150)
		var enemy3 = Factory.new_shooting_enemy(50, -150)
		addEnemy(enemy1)
		addEnemy(enemy2)
		addEnemy(enemy3)
