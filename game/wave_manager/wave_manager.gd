extends Node2D

onready var main = get_parent()
onready var hud = get_node('../Camera2D/HUD')
onready var spawner_manager = get_node('../SpawnerManager')
onready var creeps = get_node('../Creeps')

var cur_wave = 1
var cur_points = 0
var wave_points = 500
var wave_delay = 10

func start_wave():
	spawner_manager.start_wave()

func end_wave():
	cur_points = 0
	wave_delay += 1
	wave_points += cur_wave * 1000
	cur_wave += 1
	if cur_wave <= 26:
		hud.start_countdown()

func creep_exited():
	if cur_wave > 26 and get_tree():
		yield(get_tree(), 'physics_frame')
		if creeps.get_child_count() == 0:
			main.player_won()
