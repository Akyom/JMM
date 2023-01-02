class_name ActiveSpellFactory
extends Node

var spell_scenes = [
	preload("res://scenes/active_spells/repel_bullets_active_spell.tscn"),
	preload("res://scenes/active_spells/delete_bullets_active_spell.tscn"),
]

var rng = RandomNumberGenerator.new()

func _init().() -> void:
	rng.randomize()
	return

func new_active_spell_from_indx(indx: int, x: float = 0, y: float = 0) -> ActiveSpell:
	var new_spell = spell_scenes[indx].instance()
	new_spell.set_global_position(Vector2(x, y))
	new_spell.add_body()
	return new_spell

# New

func new_repel_bullets_spell(x: float = 0, y: float = 0) -> ActiveSpell:
	return new_active_spell_from_indx(0, x, y)

func new_delete_bullets_spell(x: float = 0, y: float = 0) -> ActiveSpell:
	return new_active_spell_from_indx(1, x, y)

func new_random_spell(x: float = 0, y: float = 0) -> ActiveSpell:
	return new_active_spell_from_indx(rng.randi_range(0, spell_scenes.size() - 1), x, y)
