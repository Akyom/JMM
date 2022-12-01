extends Enemy

class_name Shooting_Enemy, "res://icons/Enemy1.png"

export(int) var STILL_RANGE_MIN
export(int) var STILL_RANGE_MAX
var way = 0

export(Resource) var Bullet

func _ready() -> void:
	#$ChasingTimer.connect("timeout", self, "chasing_on_timeout")
	$FireTimer.connect("timeout", self, "fire_on_timeout")
	$AttackTimer.connect("timeout", self, "attack_on_timeout")
	$StillTimer.connect("timeout", self, "still_on_timeout")
	#$Area2D.connect("body_entered", self, "on_body_entered")

func IA():
	ShootIA()
	MoveIA()

func ShootIA():	
	if chasing and $HitTimer.is_stopped():
		if $FireTimer.is_stopped():
			$FireTimer.start()
	elif not $FireTimer.is_stopped():
		$FireTimer.stop()
	
func MoveIA():
	if chasing and $HitTimer.is_stopped():	
		if $AttackTimer.is_stopped() and $StillTimer.is_stopped():
			if distance_to_player < STILL_RANGE_MAX:
				if	distance_to_player >= STILL_RANGE_MIN:
					if way == 1:
						target_vel.x = direction_to_player.y * -1
						target_vel.y = direction_to_player.x
					else:
						target_vel.x = direction_to_player.y
						target_vel.y = direction_to_player.x * -1
					
				else:
					if way == 1:
						target_vel.x = ((direction_to_player.y * -1) + (direction_to_player.x * -1))/2
						target_vel.y = ((direction_to_player.x) + (direction_to_player.y * -1))/2
					else:
						target_vel.x = ((direction_to_player.y) + (direction_to_player.x * -1))/2
						target_vel.y = ((direction_to_player.x * -1) + (direction_to_player.y * -1))/2
			else:
				target_vel = direction_to_player
		target_vel = target_vel.normalized()
	
		
func animation():
	if linear_vel.x == 0 and linear_vel.y == 0 and (not $AttackTimer.is_stopped() or not $StillTimer.is_stopped()):
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
	else:
		.animation()
		
func fire_on_timeout():
	$AttackTimer.start()
	var wt = rand_range(0.5,4) #Mínimo siempre debe ser mayor al StillTimer wait time
	#print(wt)
	$FireTimer.wait_time = wt
	
func attack_on_timeout():
	fire(global_position.direction_to(_target.global_position))
	$StillTimer.start()
	
func still_on_timeout():
	way = randi()%2
	
func fire(shoot_v: Vector2):
	var bullet = Bullet.instance()
	bullet.init(shoot_v)
	bullet.global_position = $BulletSpawn.global_position
	get_parent().add_child(bullet)
