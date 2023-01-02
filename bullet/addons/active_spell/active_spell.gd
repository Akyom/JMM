tool
extends EditorPlugin

const editorAddon = preload("res://addons/active_spell/create_active_spell_addon.tscn")

var dockedScene

func _enter_tree():
	dockedScene = editorAddon.instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dockedScene)


func _exit_tree():
	remove_control_from_docks(dockedScene)
	dockedScene.queue_free()
