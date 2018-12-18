extends Node2D

onready var hud = get_node('../Camera2D/HUD')
onready var spawner_manager = get_node('../SpawnerManager')

var cur_wave = 1
var cur_points = 0
var wave_points = 500
var wave_delay = 10

func start_wave():
	spawner_manager.start_wave()

func end_wave():
	cur_points = 0
	cur_wave += 1
	wave_delay += .5
	wave_points += cur_wave * 500
	hud.start_countdown()
