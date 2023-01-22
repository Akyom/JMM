extends Node

var times = 0
var factory = EnemyFactory.new()
var active_spell_factory = ActiveSpellFactory.new()
var number_of_enemies = 0
var start_of_fight = false # es true en el momento en que comienza una oleada
var fighting = false # es true si se está peleando
var next_pause = false # es true si la oleada actual es la última antes de una pausa
export var NUMBER_OF_WAVES = 4

# OBS: wave number y current number of enemies no son estrictamente
#      necesarios. Deberia sacarlos?
signal wave_started(wave_number, total_number_of_enemies)
signal wave_stopped(wait_time)
signal enemy_slain(current_number_of_enemies)

func _ready() -> void:
	$OleadaTimer.connect("timeout", self, "oleada_on_timeout")
	
func _process(_delta): #0-1, pause
	if times == 0: #
		var mai = factory.new_mago_inicio(0, -100)
		addNPC(mai)
		times = times + 1
		
	if start_of_fight:
		oleada()
		emit_signal("wave_started", times, number_of_enemies)
		times = times + 1
		start_of_fight = false
		fighting = true
		
	if number_of_enemies == 0 and fighting:
		if next_pause:
			oleada()
			times = times + 1
			fighting = false
			next_pause = false
		else:	
			emit_signal("wave_stopped", $OleadaTimer.wait_time)
			$OleadaTimer.start()
			fighting = false

func addNPC(npc): #que mas?
	get_parent().add_child(npc)
	
func removeNPC(npc): #que mas?
	npc.queue_free()

func addEnemy(enemy):
	get_parent().add_child(enemy)
	
	number_of_enemies = number_of_enemies + 1

func addActiveSpell(spell):
	spell.add_body()
	get_parent().add_child(spell)
	
func enemy_died(enemy):
	enemy.queue_free()
	number_of_enemies = number_of_enemies - 1
	emit_signal("enemy_slain", number_of_enemies)

func start_fight():
	start_of_fight = true
	
func oleada_on_timeout():
	emit_signal("stop_wave_timer")
	start_of_fight = true
	
func oleada():
	print(times)
	match times:
		1: # 1-1
			var spell1 = active_spell_factory.new_repel_bullets_spell(-50, -50)
			var spell2 = active_spell_factory.new_delete_bullets_spell(20, 20)
			addActiveSpell(spell1)
			addActiveSpell(spell2)
			var enemy1 = factory.new_shooting_enemy(-50, -150)
			var enemy2 = factory.new_shooting_enemy(0, -150)
			var enemy3 = factory.new_shooting_enemy(50, -150)
			addEnemy(enemy1)
			addEnemy(enemy2)
			addEnemy(enemy3)
			$OleadaTimer.wait_time = 5
		2: # 1-2
			var enemy1 = factory.new_shooting_enemy(-100, -86)
			var enemy2 = factory.new_shooting_enemy(100, -86)
			var enemy3 = factory.new_speedster_enemy(0, 87)
			addEnemy(enemy1)
			addEnemy(enemy2)
			addEnemy(enemy3)
			$OleadaTimer.wait_time = 2
		3: # 1-3
			var enemy1 = factory.new_speedster_enemy(-400, -400)
			var enemy2 = factory.new_speedster_enemy(-400, 400)
			var enemy3 = factory.new_speedster_enemy(400, 400)
			var enemy4 = factory.new_speedster_enemy(400, -400)
			var enemy5 = factory.new_speedster_enemy(0, 0)
			addEnemy(enemy1)
			addEnemy(enemy2)
			addEnemy(enemy3)
			addEnemy(enemy4)
			addEnemy(enemy5)
			$OleadaTimer.wait_time = 10
		4: # 1-4
			var enemy1 = factory.new_shooting_enemy(0,0)
			var enemy2 = factory.new_shooting_enemy(-600, 0)
			var enemy3 = factory.new_shooting_enemy(-519, -301)
			var enemy4 = factory.new_shooting_enemy(-301, -519)
			var enemy5 = factory.new_shooting_enemy(0, -600)
			var enemy6 = factory.new_shooting_enemy(301, -519)
			var enemy7 = factory.new_shooting_enemy(519, -301)
			var enemy8 = factory.new_shooting_enemy(600, 0)
			var enemy9 = factory.new_shooting_enemy(519, 301)
			var enemy10 = factory.new_shooting_enemy(301, 519)
			var enemy11 = factory.new_shooting_enemy(0, 600)
			var enemy12 = factory.new_shooting_enemy(-301, 519)
			var enemy13 = factory.new_shooting_enemy(-519, 301)
			var enemy14 = factory.new_speedster_enemy(230, 230)
			var enemy15 = factory.new_speedster_enemy(-230, 230)
			var enemy16 = factory.new_speedster_enemy(-230, -230)
			var enemy17 = factory.new_speedster_enemy(230, -230)
			addEnemy(enemy1)
			addEnemy(enemy2)
			addEnemy(enemy3)
			addEnemy(enemy4)
			addEnemy(enemy5)
			addEnemy(enemy6)
			addEnemy(enemy7)
			addEnemy(enemy8)
			addEnemy(enemy9)
			addEnemy(enemy10)
			addEnemy(enemy11)
			addEnemy(enemy12)
			addEnemy(enemy13)
			addEnemy(enemy14)
			addEnemy(enemy15)
			addEnemy(enemy16)
			addEnemy(enemy17)
			next_pause = true
		#5: # 1-5 (pause)
			
func npc_action(npc):
	npc.player_input()
