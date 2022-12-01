extends Character

class_name Enemy, "res://icons/Enemy.png"

export(int) var VISION_RANGE

var chasing = false

export(NodePath) var target
onready var _target = get_node(target) as Node2D
var distance_to_player
var direction_to_player 

func _ready() -> void:
	$ChasingTimer.connect("timeout", self, "chasing_on_timeout")
	$Area2D.connect("body_entered", self, "on_body_entered")

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
	distance_to_player = global_position.distance_to(_target.global_position)
	direction_to_player = global_position.direction_to(_target.global_position)

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
