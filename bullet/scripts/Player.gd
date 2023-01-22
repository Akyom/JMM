extends Character

class_name Player, "res://icons/Player.png"
export(Resource) var Bullet

var shoot_v = Vector2(0,0)

signal npc_next(me)
signal health_changed(new_value)
var current_active = null

func _ready() -> void:
	#connect("active"..
	var GamePlay = get_node("../GamePlay") #Hacer un signal handler??
	minimap_icon = "player"
	connect("npc_next", GamePlay, "npc_action")

func _physics_process(_delta):
	input()
	shoot()
	animation()
	move()

func input():	
	target_vel.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	target_vel.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	target_vel = target_vel.normalized()
	
	shoot_v.x = Input.get_action_strength("shoot right") - Input.get_action_strength("shoot left")
	shoot_v.y = Input.get_action_strength("shoot down") - Input.get_action_strength("shoot up")
	
	if Input.is_action_just_pressed("active"):
		var npcs = get_tree().get_nodes_in_group("NPC")
		var npc_close = false
		for npc in npcs:
			if npc.global_position.distance_to(self.global_position) < 50:
				emit_signal("npc_next", npc)
				npc_close = true
				break
		if not npc_close:
			active()
			pass
	
	
func shoot():
	if shoot_v.length() != 0 and $ShootCooldown.is_stopped():
		fire(shoot_v)
		$ShootCooldown.start()
		
func fire(shoot_v: Vector2):
	var bullet = Bullet.instance()
	bullet.init(shoot_v)
	bullet.global_position = $BulletSpawn.global_position
	get_parent().add_child(bullet)

func take_damage(instigator: Node2D):
	var took_damage = .take_damage(instigator) # call parent's (Character) method
	# deal with the UI (hearts)
	emit_signal("health_changed", HP)
	return took_damage
	# if HP == 0 do something (emit signal i_died?)

func active():
	if (not current_active):
		return
	current_active.cast()

func drop_active():
	if (not current_active):
		return
	remove_child(current_active)
	current_active.drop()
	current_active = null
	return

func pick_up_active(spell):
	if (not $PickActiveCooldown.is_stopped()):
		return
	if (current_active):
		drop_active()
	print("PickActive")
	current_active = spell
	current_active.picked_up_by(self)
	add_child(current_active)
	$PickActiveCooldown.start()
	pass
