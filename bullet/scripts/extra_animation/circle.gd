extends Sprite

onready var playback = $AnimationTree.get("parameters/playback")
var enemy

func _ready():
	$FreeTimer.connect("timeout", self, "free_on_timeout")
	$SpawnTimer.connect("timeout", self, "spawn_on_timeout")
	$RandTimer.connect("timeout", self, "rand_on_timeout")
	#$FreeTimer.start()

func init(wt: float, e: Node2D):
	$RandTimer.wait_time = wt
	$RandTimer.start()
	enemy = e

func rand_on_timeout():
	playback.travel("circle")
	$SpawnTimer.start()
	$FreeTimer.start()

func spawn_on_timeout():
	get_parent().add_child(enemy)

func free_on_timeout():
	queue_free()
