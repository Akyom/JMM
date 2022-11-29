extends KinematicBody2D


var linear_vel = Vector2.ZERO
var MAX_SPEED = 250
var ACCELERATION = 100

var can_fire = true
var damage = false

onready var playback = $AnimationTree.get("parameters/playback")

var Bullet = preload("res://scenes/player_bullet.tscn")

func _ready() -> void:
	$ShootCooldown.connect("timeout", self, "sc_on_timeout")

func _physics_process(_delta):
	linear_vel =  move_and_slide(linear_vel, Vector2.UP)
	var target_vel_x = 0
	var target_vel_y = 0
	if $DamageTimer.is_stopped():
		target_vel_x = Input.get_action_strength("right") - Input.get_action_strength("left")
		target_vel_y = Input.get_action_strength("down") - Input.get_action_strength("up")
	var target_vel = Vector2(target_vel_x,target_vel_y)
	target_vel = target_vel.normalized()
	
	linear_vel.x = move_toward(linear_vel.x, target_vel.x * MAX_SPEED, ACCELERATION)
	linear_vel.y = move_toward(linear_vel.y, target_vel.y * MAX_SPEED, ACCELERATION)
	
	var shoot_x = Input.get_action_strength("shoot right") - Input.get_action_strength("shoot left")
	var shoot_y = Input.get_action_strength("shoot down") - Input.get_action_strength("shoot up")
	var shoot_v = Vector2(shoot_x,shoot_y)
	

	
	if shoot_v.length() != 0 and can_fire:
		fire(shoot_v)
	#Animations
	#print(linear_vel.x)
	#print(linear_vel.y)
	#print(playback.get_current_node())
	
	if linear_vel.x == 0 and linear_vel.y == 0:
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
		damage = false
	elif not damage:	
		if linear_vel.x > 10:
			playback.travel("walk right")
		elif linear_vel.x < -10:
			playback.travel("walk left")
		if linear_vel.y > 10:
			playback.travel("walk")
		elif linear_vel.y < -10:
			playback.travel("walk back")

func take_damage(instigator: Node2D):
	var push = Vector2(global_position.x - instigator.global_position.x, global_position.y - instigator.global_position.y)
	push = push.normalized()
	linear_vel.x = push.x * MAX_SPEED * 3
	linear_vel.y = push.y * MAX_SPEED * 3
	$DamageTimer.start()
	#damage = true

func fire(shoot_v: Vector2):
	var bullet = Bullet.instance()
	bullet.init(shoot_v)
	bullet.global_position = $BulletSpawn.global_position
	get_parent().add_child(bullet)
	can_fire = false
	$ShootCooldown.start()
	
func sc_on_timeout():
	can_fire = true
