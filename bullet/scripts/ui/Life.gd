extends Control

onready var player = get_node("../../../Player")
onready var heart_full = $HeartFull
onready var heart_empty = $HeartEmpty 

const HEART_SIZE_X = 50

func set_hearts_to(hearts, value):
	hearts.rect_size.x = value * HEART_SIZE_X

func set_hp(value):
	set_hearts_to(heart_full, value)
	
func set_max_hp(value):
	set_hearts_to(heart_empty, value)
	set_hearts_to(heart_full, value)

func _ready():
	set_max_hp(player.MAX_HP)
	player.connect("health_changed", self, "set_hp")
