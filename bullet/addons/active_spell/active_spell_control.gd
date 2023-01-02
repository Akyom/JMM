tool
extends Node

onready var create_spell_button = $CreateSpellButton
onready var create_spell_popup_menu = $CreateSpellPopupMenu
onready var remove_spell_popup_menu = $RemoveSpellPopupMenu
func _ready():
	pass

func _on_CreateSpellButton_pressed():
	create_spell_popup_menu.popup_centered_minsize(Vector2(640, 100))
	pass # Replace with function body.


func _on_RemoveSpellButton_pressed():
	remove_spell_popup_menu.popup_centered_minsize(Vector2(640, 100))
	pass # Replace with function body.
