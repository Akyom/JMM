extends Control

onready var GamePlay = get_node("../../../GamePlay")
onready var wave_counter = get_node("LabelContainer/WaveCounter")
onready var enemies_counter = get_node("LabelContainer/EnemiesCounter")

var total_number_of_enemies = 0
var total_number_of_waves = 0
var starting_wave = 0

func string_format(current_number, total_number):
	return "%d/%d" % [current_number, total_number]

func set_up_enemies_label(number_of_enemies):
	total_number_of_enemies = number_of_enemies
	enemies_counter.text = string_format(total_number_of_enemies, total_number_of_enemies)
	
func change_n_enemies(current_number_of_enemies):
	enemies_counter.text = string_format(current_number_of_enemies, total_number_of_enemies)

func set_up_wave_label(number_of_waves):
	total_number_of_waves = number_of_waves
	wave_counter.text = "%d" % number_of_waves
	
func change_n_wave(current_wave):
	wave_counter.text = str(current_wave)

func set_up_labels(current_wave, total_number_of_enemies):
	set_up_enemies_label(total_number_of_enemies)
	change_n_wave(current_wave)

func _ready():
	## intialize bars
	set_up_enemies_label(0)
	set_up_wave_label(0)
	
	GamePlay.connect("wave_started", self, "set_up_labels")
	GamePlay.connect("enemy_slain", self, "change_n_enemies")
