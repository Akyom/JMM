extends Character

signal end_pause(me)
signal bye(me)

func _ready() -> void:
	var GamePlay = get_node("../GamePlay")
	connect("end_pause", GamePlay, "start_fight")
	connect("bye", GamePlay, "removeNPC")
	
func _physics_process(_delta):
	animation()
					

func player_input():
	emit_signal("end_pause")
	emit_signal("bye", self)
	queue_free()

func get_minimap_icon(tab):
	if (tab):
		return $MinimapIcon.duplicate()
	return $GenericMinimapIcon.duplicate()
