extends Area2D

class_name Bullet

export(int) var SPEED
export(int) var G = 1e7 # 2000000
export(String) var target_group
export(String) var DAMAGE = 1
var linear_vel = Vector2.ZERO
var linear_acc = Vector2.ZERO
var old_linear_acc = linear_acc
var rejecting = false
var _target
var ACCEL = 0

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	
func init(shoot_v: Vector2, acc = 0):
	linear_vel = shoot_v
	linear_vel *= SPEED
	ACCEL = acc
	rotation = linear_vel.angle()
	#print(linear_vel)
	
func compute_repel_accel() -> void:
	linear_acc = _target.global_position.direction_to(global_position)
	var distance = _target.global_position.distance_to(global_position)
	linear_acc = linear_acc.normalized()
	ACCEL = G / (distance * distance)
	linear_acc *= ACCEL

func _physics_process(delta: float) -> void:
	if (rejecting):
		compute_repel_accel() # compute linear_acc at t

		### Verlet's method
		# 1. x(t+dt) = x(t) + v(t) * dt + 0.5 * a(t) * dt^2
		# 1.5 calculate a(t+dt)
		# 2. v(t+dt) = v(t) + 0.5 * (a(t) + a(t+dt)) * dt
		
		# Step 1
		position += linear_vel * delta + 0.5 * linear_acc * delta * delta

		# Step 1.5
		old_linear_acc = linear_acc # first save a(t)
		compute_repel_accel() # compute linear_acc at t+dt

		# Step 2
		linear_vel += 0.5 * delta * (old_linear_acc + linear_acc)
		
	else:
		position += linear_vel * delta	
	
func on_body_entered(body: Node):
	#print(body.name)
	if(body.is_in_group(target_group)) and body.has_method("take_damage"):
		var took_damage = body.take_damage(self)
		if took_damage:
			queue_free()
	elif(body.is_in_group("Wall")):
		queue_free()
