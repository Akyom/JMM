extends MarginContainer

onready var player = get_node("../../Player")
onready var map = get_node("../../Map")
export var zoom = 0.6

onready var grid = $MarginContainer/MapSpace
var scale
var markers = {}
var zoomed_map

var group_names = ["Spell", "Enemy", "NPC", "Player"]

func _ready():
	scale = grid.rect_size / (get_viewport_rect().size * zoom)
	#print(get_viewport_rect().size)
	var map_size = map.get_node("TileMap2").get_used_rect().size
	zoomed_map = map.duplicate()
	grid.add_child(zoomed_map)
	
	map_size = map_size * 32
	#print(map_size)
	scale = grid.rect_size / map_size
	zoomed_map.scale = scale
	zoomed_map.position += grid.rect_size / 2
	zoomed_map.get_node("TileMap").set_collision_mask_bit(0, false)
	zoomed_map.get_node("TileMap2").set_collision_mask_bit(0, false)
	zoomed_map.get_node("TileMap").set_collision_layer_bit(0, false)
	zoomed_map.get_node("TileMap2").set_collision_layer_bit(0, false)
	
	pass

func _process(delta):
	
	for key in markers:
		var marker = markers[key]
		marker.queue_free()
	markers.clear()
	
	for group_name in group_names:
		var items = get_tree().get_nodes_in_group(group_name)
		for item in items:
			if (not item.minimap_showable()):
				continue
			var new_marker = item.get_minimap_icon(player.tab_pressing)
			grid.add_child(new_marker)
			new_marker.show()
			markers[item] = new_marker
		
	for item in markers:
		var object_position = item.position * scale + grid.rect_size / 2
		markers[item].position = object_position
	
	pass
