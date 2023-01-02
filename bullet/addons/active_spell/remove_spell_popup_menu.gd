tool
extends WindowDialog

onready var ActiveSpellName = $VBoxContainer/HBoxContainer2/ActiveSpellName
var snake_case_suffix = "_active_spell"
var script_extension = ".gd"
var scene_extension = ".tscn"
var pascal_case_suffix = "ActiveSpell"
var scripts_path = "res://scripts/active_spells/"
var scenes_path = "res://scenes/active_spells/"
var class_template_file_path = "res://addons/active_spell/active_spell_class_template.txt"
var scene_template_file_path = "res://addons/active_spell/active_spell_scene_template.txt"
var factory_path = "res://scripts/active_spells/active_spell_factory.gd"

func _ready():
	pass

func generate_class_file_name(snake_case_name: String) -> String:
	return snake_case_name + snake_case_suffix + script_extension

func generate_scene_file_name(snake_case_name: String) -> String:
	return snake_case_name + snake_case_suffix + scene_extension

func _on_RemoveButton_pressed() -> void:
	var snake_case = ActiveSpellName.text
	var class_file_name = generate_class_file_name(snake_case)
	var class_file_path = scripts_path + class_file_name
	var dir = Directory.new()
	dir.remove(class_file_path)
	
	var scene_file_name = generate_scene_file_name(snake_case)
	var scene_file_path = scenes_path + scene_file_name
	dir.remove(scene_file_path)
	self.hide()
	
	var scene_file_preload = "\tpreload(\"res://scenes/active_spells/" + scene_file_name + "\"),\n"
	
	var factory_file = File.new()
	factory_file.open(factory_path, File.READ)
	var content = factory_file.get_as_text()
	
	var start = content.find("[", 0)
	var end = content.find(scene_file_preload, 0)
	var arr_indx = content.countn("\n", start, end) - 1
	
	factory_file.close()
	
	var new_func = "func new_" + snake_case + "_spell(x: float = 0, y: float = 0) -> ActiveSpell:\n\treturn new_active_spell_from_indx(" + str(arr_indx) +", x, y)\n\n"
	
	content = content.replace(new_func, "")
	
	factory_file = File.new()
	content = content.replace(scene_file_preload, "")
	
	factory_file.open(factory_path, File.WRITE)
	factory_file.store_string(content)
	factory_file.close()
	
	ActiveSpellName.clear()
	pass # Replace with function body.


func _on_CancelButton_pressed():
	self.hide()
	pass # Replace with function body.
