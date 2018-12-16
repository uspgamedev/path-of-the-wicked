extends Node2D

const CREEP_DB = preload('res://creeps/creep_db.gd')

onready var creeps = get_node('../Creeps')
onready var wave_manager = get_node('../WaveManager')
onready var creep_db = CREEP_DB.new()

const IDX_RANGE = 25

var unique_id = 1
var min_idx = 0
var max_idx = 5

func _ready():
	for spawner in self.get_children():
		spawner.get_node('Timer').connect('timeout', self, 'spawn_creep', [spawner])

func spawn_creep(spawner):
	if wave_manager.cur_points <= wave_manager.wave_points:
		randomize()
		var creep_idx = min_idx + randi() % (max_idx - min_idx)
		var creep = creep_db.CREEPS[creep_idx].instance()
		creep.name = str(creep.name, '-', unique_id)
		unique_id += 1
		creep.offset = Vector2(-40 + randi() % 81, -30 + randi() % 61)
		creep.position = spawner.position + creep.offset
		creep.spawner = spawner
		creeps.add_child(creep)
		wave_manager.cur_points += creep.value
	else:
		for spawner in self.get_children():
			spawner.get_node('Timer').stop()
		wave_manager.end_wave()

func start_wave():
	max_idx = min(wave_manager.cur_wave + 4, creep_db.CREEPS.size())
	min_idx = max(0, max_idx - IDX_RANGE)
	for spawner in self.get_children():
		spawner.get_node('Timer').start()
