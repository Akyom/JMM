class_name ActiveSpell
extends Area2D

# Base class for every active spell.
# Active spells should always inherit from this class and should
# always be used in a scene with at least:
# - Sprite named Sprite
# - CollisionShape2D named CollisionShape2D

## Variables:
## spell_owner: Stores the carrier of the active spell.
##				Has value null if the spell is on the floor or
##				not present on the scene. This variable is useful
##				when implementing its ability.
var spell_owner: Character = null

## has_body: Boolean which is true if the active spell's sprite is 
##			 displayed on the scene.
var has_body: bool = true

## indx: Integer index of the spell. Will probably be useful later.
##       Active spells should change this value
var indx: int = 0


## _ready(): Sets a signal to body_entered
func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	add_to_group("Spell")

## remove_body(): Removes the body of the active spell from the scene.
func remove_body() -> void:
	self.get_node("Sprite").set_deferred("visible", false)
	self.get_node("CollisionShape2D").set_deferred("disabled", true)

## add_body(): Adds the body of the active spell to the scene.
func add_body() -> void:
	self.get_node("Sprite").set_deferred("visible", true)
	self.get_node("CollisionShape2D").set_deferred("disabled", false)

## cast(): Called when the owner activates the active spell. 
##		   An active spell should override this method.
func cast() -> void:
	pass

## picked_up_by(body): Called when a node picks up the active spell. 
## body: Node
##		 The one that picks up the active spell, usually the Player.
func picked_up_by(body: Node) -> void:
	remove_body()
	spell_owner = body
	set_deferred("Monitoring", false)

## drop(): Called when the active spell is dropped on the floor.
func drop() -> void:
	add_body()
	get_parent().add_child(self)
	set_deferred("Monitoring", true)
	self.global_position.x = spell_owner.global_position.x
	self.global_position.y = spell_owner.global_position.y
	spell_owner = null

## on_body_entered(body): Called when some body enters the active spell's 
##                        area's / CollisionShape2D's shape.
func on_body_entered(body: Node) -> void:
	if (body.is_in_group("Player") and (not spell_owner)):
		body.pick_up_active(self)
		return
	return
