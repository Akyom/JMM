extends Character

class_name Player, "res://icons/Player.png"

export(Resource) var Bullet

var shoot_v = Vector2(0,0)

func _physics_process(_delta):
	input()
	animation()
	move()

func input():	
	target_vel.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	target_vel.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	target_vel = target_vel.normalized()
	
	shoot_v.x = Input.get_action_strength("shoot right") - Input.get_action_strength("shoot left")
	shoot_v.y = Input.get_action_strength("shoot down") - Input.get_action_strength("shoot up")
		
	if shoot_v.length() != 0 and $ShootCooldown.is_stopped():
		fire(shoot_v)
		$ShootCooldown.start()
		
func fire(shoot_v: Vector2):
	var bullet = Bullet.instance()
	bullet.init(shoot_v)
	bullet.global_position = $BulletSpawn.global_position
	get_parent().add_child(bullet)

	
	
