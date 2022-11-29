extends KinematicBody2D

var linear_vel = Vector2.ZERO
var MAX_SPEED = 100
var DMG_SPEED = 250
var ACCELERATION = 100
var VISION_RANGE = 300
var STILL_RANGE_MIN = 100
var STILL_RANGE_MAX = 150

var chasing = false
var damage = false
var way = 0

export(NodePath) var target
onready var _target = get_node(target) as Node2D

onready var playback = $AnimationTree.get("parameters/playback")

var Bullet = preload("res://scenes/e1_bullet.tscn")

func _ready() -> void:
	$FireTimer.connect("timeout", self, "fire_on_timeout")
	$ChasingTimer.connect("timeout", self, "chasing_on_timeout")
	$AttackTimer.connect("timeout", self, "attack_on_timeout")
	$StillTimer.connect("timeout", self, "still_on_timeout")

func _physics_process(_delta):
	#print(chasing)
	#print(not $ChasingTimer.is_stopped())
	#print("")
	linear_vel =  move_and_slide(linear_vel, Vector2.UP)
	var distance_to_player = global_position.distance_to(_target.global_position)
	var direction_to_player = global_position.direction_to(_target.global_position)
	
	if _target:
		if distance_to_player < VISION_RANGE:
			chasing = true
			if not $ChasingTimer.is_stopped():
				$ChasingTimer.stop()
		elif chasing and $ChasingTimer.is_stopped():
			$ChasingTimer.start()
				
	var target_vel = Vector2(0,0)
	if chasing:
		var d = direction_to_player
		if $FireTimer.is_stopped():
			$FireTimer.start()
		if $AttackTimer.is_stopped() and $StillTimer.is_stopped():
			if distance_to_player < STILL_RANGE_MAX:
				if	distance_to_player >= STILL_RANGE_MIN:
					if way == 1:
						target_vel.x = d.y * -1
						target_vel.y = d.x
					else:
						target_vel.x = d.y
						target_vel.y = d.x * -1
					
				else:
					if way == 1:
						target_vel.x = ((d.y * -1) + (d.x * -1))/2
						target_vel.y = ((d.x) + (d.y * -1))/2
					else:
						target_vel.x = ((d.y) + (d.x * -1))/2
						target_vel.y = ((d.x * -1) + (d.y * -1))/2
			else:
				target_vel = direction_to_player
		target_vel = target_vel.normalized()
	elif not $FireTimer.is_stopped():
		$FireTimer.stop()
		
	linear_vel.x = move_toward(linear_vel.x, target_vel.x * MAX_SPEED, ACCELERATION)
	linear_vel.y = move_toward(linear_vel.y, target_vel.y * MAX_SPEED, ACCELERATION)
	#else:
		#se mueve aleatoriamente
			
	
			
	
	#if dentro
	#if suficientemente cerca:
		#mover a los lados segun timer
	#elif
	#var target_vel_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#var target_vel_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	#var target_vel = Vector2(target_vel_x,target_vel_y)
	#target_vel = target_vel.normalized()
	
	#linear_vel.x = move_toward(linear_vel.x, target_vel.x * MAX_SPEED, ACCELERATION)
	#linear_vel.y = move_toward(linear_vel.y, target_vel.y * MAX_SPEED, ACCELERATION)
	if linear_vel.x == 0 and linear_vel.y == 0:
		if $AttackTimer.is_stopped() and $StillTimer.is_stopped():
			var current_node = playback.get_current_node()
			#print(current_node)
			if current_node == "walk":
				playback.travel("idle")
			elif current_node == "walk back":
				playback.travel("idle back")
			elif current_node == "walk right":
				playback.travel("idle right")
			elif current_node == "walk left":
				playback.travel("idle left")
		else:
			if abs(direction_to_player.x) > abs(direction_to_player.y):
				if direction_to_player.x > 0:
					playback.travel("idle right")
				else:
					playback.travel("idle left")
			else:	
				if direction_to_player.y > 0:
					playback.travel("idle")
				else:
					playback.travel("idle back")
		damage = false
	elif not damage:	
		if abs(linear_vel.x) > abs(linear_vel.y):
			if linear_vel.x > 10:
				playback.travel("walk right")
			elif linear_vel.x < -10:
				playback.travel("walk left")
		else:
			if linear_vel.y > 10:
				playback.travel("walk")
			elif linear_vel.y < -10:
				playback.travel("walk back")


func take_damage(instigator: Node2D):
	var push = Vector2(global_position.x - instigator.global_position.x, global_position.y - instigator.global_position.y)
	push = push.normalized()
	linear_vel.x = push.x * MAX_SPEED * 3
	linear_vel.y = push.y * MAX_SPEED * 3
	damage = true
	
func fire():
	var bullet = Bullet.instance()
	bullet.init(global_position.direction_to(_target.global_position))
	bullet.global_position = $BulletSpawn.global_position
	get_parent().add_child(bullet)
	$StillTimer.start()
	
	
func fire_on_timeout():
	$AttackTimer.start()
	var wt = rand_range(0.5,4) #Mínimo siempre debe ser mayor al StillTimer wait time
	#print(wt)
	$FireTimer.wait_time = wt
		
func chasing_on_timeout():
	#print("chasing timeout")
	chasing = false
	
func attack_on_timeout():
	fire()

func still_on_timeout():
	way = randi()%2
