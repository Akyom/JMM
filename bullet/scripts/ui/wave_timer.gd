extends Control

onready var GamePlay = get_node("../../../GamePlay")
onready var oleada_timer = get_node("../../../GamePlay/OleadaTimer")
onready var progress_bar = $TextureProgress

var value_per_second = 0
var active = false

func hide_progress_bar():
	active = false
	progress_bar.set_visible(false)
	
func show_progress_bar():
	active = true
	progress_bar.set_visible(true)
	
func start_wave_timer(wait_time):
	value_per_second = 100 / wait_time
	progress_bar.value = 100
	show_progress_bar()
	
# Not beeing used. Perhaps should be removed.
func stop_wave_timer(current_wave):
	hide_progress_bar()
	
func _process(delta):
	if active:
		progress_bar.value = oleada_timer.time_left * value_per_second
		if progress_bar.value <= 0:
			hide_progress_bar() 
	
func _ready():
	GamePlay.connect("wave_stopped", self, "start_wave_timer")
	
	hide_progress_bar()
