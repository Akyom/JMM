extends Character

class_name Enemy, "res://icons/Enemy.png"

export(int) var VISION_RANGE
export(int) var DAMAGE = 1

var chasing = false

export(NodePath) var target = "../Player"
onready var _target = get_node(target) as Node2D
var distance_to_player
var direction_to_player
var indx = -1

signal i_died(me)

func _ready() -> void:
	minimap_icon = "enemy"
	$ChasingTimer.connect("timeout", self, "chasing_on_timeout")
	$Area2D.connect("body_entered", self, "on_body_entered")
	var GamePlay = get_node("../GamePlay")
	minimap_icon = "enemy2"
	connect("i_died", GamePlay, "enemy_died")

func _physics_process(_delta):
	where_player()
	chase()
	IA()
	animation()
	move()

func IA():	
	target_vel.x = 0
	target_vel.y = 0
	if chasing and $HitTimer.is_stopped():
		target_vel.x = direction_to_player.x
		target_vel.y = direction_to_player.y
			
func where_player():
	if (_target != null):
		distance_to_player = global_position.distance_to(_target.global_position)
	else:
		distance_to_player = 10000
	if (_target != null):
		direction_to_player = global_position.direction_to(_target.global_position)
	else:
		direction_to_player = Vector2(0, 0)

func chase():
	if _target:
		if distance_to_player < VISION_RANGE:
			chasing = true
			if not $ChasingTimer.is_stopped():
				$ChasingTimer.stop()
		elif chasing and $ChasingTimer.is_stopped():
			$ChasingTimer.start()	
	
func chasing_on_timeout():
	#print("chasing timeout")
	chasing = false

func on_body_entered(body: Node):
	#print(body)
	if(body.is_in_group("Player")) and body.has_method("take_damage"):
		body.take_damage(self)
		$HitTimer.start()

