extends Character

class_name Enemy, "res://icons/Enemy.png"

export(int) var VISION_RANGE
export(int) var STILL_RANGE_MIN
export(int) var STILL_RANGE_MAX

var chasing = false
var way = 0

export(NodePath) var target
onready var _target = get_node(target) as Node2D
var distance_to_player
var direction_to_player 

func _ready() -> void:
	$FireTimer.connect("timeout", self, "fire_on_timeout")
	$ChasingTimer.connect("timeout", self, "chasing_on_timeout")
	$AttackTimer.connect("timeout", self, "attack_on_timeout")
	$StillTimer.connect("timeout", self, "still_on_timeout")
	$Area2D.connect("body_entered", self, "on_body_entered")

func _physics_process(_delta):
	where_player()
	chase()
	IA()
	animation()
	move()
	

				



			
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
	
func fire_on_timeout():
	$AttackTimer.start()
	var wt = rand_range(0.5,4) #Mínimo siempre debe ser mayor al StillTimer wait time
	#print(wt)
	$FireTimer.wait_time = wt
		
func chasing_on_timeout():
	#print("chasing timeout")
	chasing = false
	


func on_body_entered(body: Node):
	#print(body)
	if(body.is_in_group("Player")) and body.has_method("take_damage"):
		body.take_damage(self)
		$HitTimer.start()
