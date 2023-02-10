extends Control

onready var progress = $TextureProgress
onready var player = get_node("../../Player")

var active_spell = null
var active_spell_sprite = null
var spell_timer = null

var active = false
var value_per_second = 0

func hide_spell_info():
	active = false
	self.set_visible(false)

func show_spell_info():
	active = true
	self.set_visible(true)

func set_active_spell(spell):
	active_spell = spell
	spell_timer = spell.get_node("Cooldown")
	value_per_second = 100 / spell_timer.wait_time
	
	active_spell_sprite = spell.get_node("Sprite").duplicate()
	add_child(active_spell_sprite)
	active_spell_sprite.position = self.rect_size / 2
	active_spell_sprite.scale *= 4
	active_spell_sprite.show()
	
	show_spell_info()
	
func _process(delta):
	if active:
		progress.value = 100 - value_per_second * spell_timer.time_left

func _ready():
	player.connect("spell_picked", self, "set_active_spell")
	player.connect("spell_dropped", self, "hide_spell_info")
	
	hide_spell_info()
