extends Area2D

class_name Bullet

export(int) var SPEED
export(String) var target_group
export(String) var DAMAGE = 1
var linear_vel = Vector2.ZERO


func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	
func init(shoot_v: Vector2):
	linear_vel = shoot_v
	rotation = linear_vel.angle()
	#print(linear_vel)
	
func _physics_process(delta: float) -> void:
	position.x += linear_vel.x * SPEED * delta
	position.y += linear_vel.y * SPEED * delta
	
func on_body_entered(body: Node):
	#print(body.name)
	if(body.is_in_group(target_group)) and body.has_method("take_damage"):
		var took_damage = body.take_damage(self)
		if took_damage:
			queue_free()
	elif(body.is_in_group("Wall")):
		queue_free()
