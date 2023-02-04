extends Node2D
#AAAAAAAAAAA
var start_game = true
var JMM = preload("res://scenes/Jmm.tscn")
var jmm_node

func _ready():
	$StartTimer.connect("timeout", self, "start_on_timeout")
	$WaitTimer.connect("timeout", self, "wait_on_timeout")

func _process(_delta): 
	if start_game:
		$StartTimer.start()
		start_game = false

func start_on_timeout():
	add_child(JMM.instance())
	
func wait_on_timeout():
	print("pre queue free")
	jmm_node.queue_free()
	start_game = true
	
func player_died(player):
	jmm_node = player.get_parent()
	$WaitTimer.start()
