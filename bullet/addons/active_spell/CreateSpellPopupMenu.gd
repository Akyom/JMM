tool
extends Popup

onready var CreateButton = $VBoxContainer/HBoxContainer/CreateButton
onready var CancelButton = $VBoxContainer/HBoxContainer/CancelButton
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

func to_pascal_case(text) -> String:
	var l = text.length()
	var ret = text
	for i in l:
		if (ret[i] == '_'):
			if (i + 1 < l):
				ret[i + 1] = ret[i + 1].to_upper()
	ret[0] = ret[0].to_upper()
	ret = ret.replace('_', '')
	return ret

func generate_class_file_name(snake_case_name: String) -> String:
	return snake_case_name + snake_case_suffix + script_extension

func generate_scene_file_name(snake_case_name: String) -> String:
	return snake_case_name + snake_case_suffix + scene_extension

func generate_class_file_content(pascal_case_name: String) -> String:
	var class_file_first_line = "class_name " + pascal_case_name + pascal_case_suffix + "\n"
	var class_template_file = File.new()
	class_template_file.open(class_template_file_path, File.READ)
	return class_file_first_line + class_template_file.get_as_text() + "\n"
	
func generate_scene_file_content(class_script_name: String) -> String:
	var scene_file_content_prelude = "[gd_scene load_steps=4 format=2]\n\n[ext_resource path=\"res://scripts/active_spells/" + class_script_name + "\" type=\"Script\" id=1]\n[ext_resource path=\"res://icon.png\" type=\"Texture\" id=2]\n\n"
	var scene_template_file = File.new()
	scene_template_file.open(scene_template_file_path, File.READ)
	return scene_file_content_prelude + scene_template_file.get_as_text() + "\n"
	
func fill_active_spell_factory(scene_file_path: String, scene_file_name: String, snake_case_name: String) -> void:
	var scene_file_preload = "preload(\"res://scenes/active_spells/" + scene_file_name + "\"),"
	var factory_file = File.new()
	factory_file.open(factory_path, File.READ)
	var number = 0
	var line = factory_file.get_line()
	while(line.length() < 1 || line[0] != ']'):
		line = factory_file.get_line()
		number += 1
	factory_file.close()
	factory_file.open(factory_path, File.READ)
	var content = factory_file.get_as_text()
	
	var index = 0
	var arr_indx = 0
	var add_arr_indx = 0
	while(content[index] != ']'):
		if (content[index] == '['):
			add_arr_indx += 1
		if (content[index] == '\n'):
			arr_indx += add_arr_indx
		index += 1
	arr_indx -= 1
	content = content.insert(index, "\t" + scene_file_preload + "\n")
	
	var new_func = "func new_" + snake_case_name + "_spell(x: float = 0, y: float = 0) -> ActiveSpell:\n\treturn new_active_spell_from_indx(" + str(arr_indx) +", x, y)"
	
	index = content.find("# New", 0)
	if (index < 0):
		return
	index += 7
	content = content.insert(index, new_func + "\n\n")
	factory_file.close()
	factory_file.open(factory_path, File.WRITE)
	factory_file.store_string(content)
	factory_file.close()

func generate_files(snake_case_name: String, pascal_case_name: String) -> void:
	var class_file_name = generate_class_file_name(snake_case_name)
	var scene_file_name = generate_scene_file_name(snake_case_name)
	var class_file_content = generate_class_file_content(pascal_case_name)
	var scene_file_content = generate_scene_file_content(class_file_name)
	
	var class_file_path = scripts_path + class_file_name
	var scene_file_path = scenes_path + scene_file_name
	
	var class_file = File.new()
	class_file.open(class_file_path, File.WRITE)
	class_file.store_string(class_file_content)
	class_file.close()
	
	var scene_file = File.new()
	scene_file.open(scene_file_path, File.WRITE)
	scene_file.store_string(scene_file_content)
	scene_file.close()
	
	fill_active_spell_factory(scene_file_path, scene_file_name, snake_case_name)
	
func _on_CreateButton_pressed():
	var name = ActiveSpellName.text
	var snake_case = name
	var pascal_case = to_pascal_case(name)
	generate_files(snake_case, pascal_case)
	
	ActiveSpellName.clear()
	self.hide()
	pass # Replace with function body.

func _on_CancelButton_pressed():
	self.hide()

