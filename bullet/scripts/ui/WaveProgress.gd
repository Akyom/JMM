extends Control

onready var GamePlay = get_node("../../../GamePlay")
onready var progress_bar = $TextureProgress

var value_per_enemy = 0

func hide_progress_bar():
	progress_bar.set_visible(false)
	
func show_progress_bar():
	progress_bar.set_visible(true)

func set_up_progress_bar(total_number_of_enemies):
	progress_bar.value = 100
	value_per_enemy = 100 / total_number_of_enemies
	show_progress_bar()
	
func decrease_progress_bar(current_number_of_enemies):
	progress_bar.value = value_per_enemy * current_number_of_enemies
	if current_number_of_enemies == 0:
		hide_progress_bar()

func _ready():
	GamePlay.connect("start_wave_progress", self, "set_up_progress_bar")
	GamePlay.connect("decrease_wave_progress", self, "decrease_progress_bar")

	hide_progress_bar()
