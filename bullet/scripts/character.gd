extends KinematicBody2D

class_name Character, "res://icons/Character.png"

var linear_vel = Vector2.ZERO
var target_vel = Vector2(0,0)
export(int) var MAX_SPEED
export(int) var DMG_SPEED = 250 
export(int) var ACCELERATION
export(int) var MAX_HP = 2
export(int) var HP = 2

var update_animation = true

export var invulnerability = false
export var movil = true

onready var playback = $AnimationTree.get("parameters/playback")

signal i_died(me)

func move():
	if movil:
		linear_vel.x = move_toward(linear_vel.x, target_vel.x * MAX_SPEED, ACCELERATION)
		linear_vel.y = move_toward(linear_vel.y, target_vel.y * MAX_SPEED, ACCELERATION)
		linear_vel =  move_and_slide(linear_vel, Vector2.UP)
	
func animation():
	if HP > 0:
		if linear_vel.x == 0 and linear_vel.y == 0:
			var current_node = playback.get_current_node()
			#print(current_node)
			if current_node == "walk" or current_node == "appear":
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
	else:
		playback.travel("disappear")

func take_damage(instigator: Node2D):
	if not invulnerability:
		var push = Vector2(global_position.x - instigator.global_position.x, global_position.y - instigator.global_position.y)
		push = push.normalized()
		linear_vel.x = push.x * DMG_SPEED * 3
		linear_vel.y = push.y * DMG_SPEED * 3
		$DamageTimer.start()
		HP = HP - instigator.DAMAGE
		if HP <= 0:
			emit_signal("i_died", self)
	return not invulnerability

func setPosition(x, y):
	global_position = Vector2(x, y)
	pass

func get_minimap_icon(tab):
	return $MinimapIcon.duplicate()
	
func minimap_showable():
	return true
