extends KinematicBody2D

var linear_vel = Vector2.ZERO
var MAX_SPEED = 180
var DMG_SPEED = 250
var ACCELERATION = 100
var VISION_RANGE = 300

var chasing = false
#var damage = false

export(NodePath) var target
onready var _target = get_node(target) as Node2D

onready var playback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	$ChasingTimer.connect("timeout", self, "chasing_on_timeout")
	$Area2D.connect("body_entered", self, "on_body_entered")

func _physics_process(_delta):
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
	if chasing and $HitTimer.is_stopped():
		target_vel.x = direction_to_player.x
		target_vel.y = direction_to_player.y
	linear_vel.x = move_toward(linear_vel.x, target_vel.x * MAX_SPEED, ACCELERATION)
	linear_vel.y = move_toward(linear_vel.y, target_vel.y * MAX_SPEED, ACCELERATION)
		
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
	elif $DamageTimer.is_stopped():	
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
	$DamageTimer.start()	

func chasing_on_timeout():
	#print("chasing timeout")
	chasing = false

func on_body_entered(body: Node):
	print(body)
	if(body.is_in_group("Player")) and body.has_method("take_damage"):
		body.take_damage(self)
		$HitTimer.start()
