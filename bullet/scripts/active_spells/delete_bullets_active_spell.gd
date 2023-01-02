class_name DeleteBulletsActiveSpell
extends ActiveSpell

## A spell that when casted will erase every bullet that is currently
## on the scene.

func _ready():
	indx = 1
	pass

func cast():
	if ((not $Cooldown.is_stopped()) || (not spell_owner)):
		return
	var bullets = spell_owner.get_tree().get_nodes_in_group("BULLET")
	for bullet in bullets:
		bullet.queue_free()
	$Cooldown.start()
