extends MarginContainer

onready var player = get_node("../../Player")
export var zoom = 0.6

onready var grid = $MarginContainer/MapSpace
onready var player_icon = $MarginContainer/MapSpace/Player
onready var enemy_icon = $MarginContainer/MapSpace/Enemy
onready var enemy1_icon = $MarginContainer/MapSpace/Enemy1
onready var enemy2_icon = $MarginContainer/MapSpace/Enemy2

onready var icons = {"enemy": enemy_icon, "player": player_icon, "enemy1": enemy1_icon, "enemy2": enemy2_icon}

var scale
var markers = {}

func _ready():
	player_icon.position = grid.rect_size / 2
	scale = grid.rect_size / (get_viewport_rect().size * zoom)
	print(get_viewport_rect().size)
	var map_size = player.get_parent().get_node("TileMap2").get_used_rect().size
	map_size = map_size * 32
	print(map_size)
	scale = grid.rect_size / map_size
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var spells = get_tree().get_nodes_in_group("Spell")
	for enemy in enemies:
		var new_marker = icons[enemy.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[enemy] = new_marker
	for spell in spells:
		var new_marker = spell.Sprite.duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[spell] = new_marker
	pass

func _process(delta):
	if (!player):
		return
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var spells = get_tree().get_nodes_in_group("Spell")
	for key in markers:
		var marker = markers[key]
		marker.queue_free()
	markers.clear()
	for enemy in enemies:
		var new_marker = icons[enemy.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[enemy] = new_marker
	for spell in spells:
		if (not spell.has_body):
			continue
		var new_marker = spell.icon.duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[spell] = new_marker
		
	for item in markers:
		var object_position = item.position * scale + grid.rect_size / 2
		object_position.x = clamp(object_position.x, 0, grid.rect_size.x)
		object_position.y = clamp(object_position.y, 0, grid.rect_size.y)
		markers[item].position = object_position
	player_icon.position = player.position * scale + grid.rect_size / 2
	print(markers.size())
	pass
