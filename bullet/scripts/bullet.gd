extends Area2D

class_name Bullet

export(int) var SPEED
export(int) var G = 2000000
export(String) var target_group
export(String) var DAMAGE = 1
var linear_vel = Vector2.ZERO
var linear_acc = Vector2.ZERO
var rejecting = false
var _target
var ACCEL = 0

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	
func init(shoot_v: Vector2, acc = 0):
	linear_vel = shoot_v
	linear_vel.x = linear_vel.x * SPEED
	linear_vel.y = linear_vel.y * SPEED
	ACCEL = acc
	rotation = linear_vel.angle()
	#print(linear_vel)
	
func _physics_process(delta: float) -> void:
	if (rejecting):
		linear_acc = _target.global_position.direction_to(global_position)
		var distance = _target.global_position.distance_to(global_position)
		linear_acc = linear_acc.normalized()
		ACCEL = G / (distance * distance)
		linear_acc.x *= ACCEL
		linear_acc.y *= ACCEL
		linear_vel.x += linear_acc.x * delta
		linear_vel.y += linear_acc.y * delta
		
	position.x += linear_vel.x * delta
	position.y += linear_vel.y * delta
		
	
func on_body_entered(body: Node):
	#print(body.name)
	if(body.is_in_group(target_group)) and body.has_method("take_damage"):
		var took_damage = body.take_damage(self)
		if took_damage:
			queue_free()
	elif(body.is_in_group("Wall")):
		queue_free()
