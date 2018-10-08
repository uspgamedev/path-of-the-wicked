extends Node2D

const CREEP_DB = preload('res://creeps/creep_db.gd')

onready var creeps = get_node('../Creeps')
onready var wave_manager = get_node('../WaveManager')
onready var creep_db = CREEP_DB.new()

var unique_id = 1

func _ready():
	for spawner in self.get_children():
		spawner.get_node('Timer').connect('timeout', self, 'spawn_creep', [spawner])

func spawn_creep(spawner):
	if wave_manager.cur_points <= wave_manager.wave_points:
		randomize()
		var creep_idx = randi() % min((6 + wave_manager.cur_wave), creep_db.CREEPS.size())
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
	for spawner in self.get_children():
		spawner.get_node('Timer').start()
