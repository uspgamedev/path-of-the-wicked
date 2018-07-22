extends Node2D

onready var creeps = get_node('../Creeps')

func _ready():
	for spawner in self.get_children():
		spawner.get_node('Timer').connect('timeout', self, 'spawn_creep', [spawner])

func spawn_creep(spawner):
	randomize()
	var creep_idx = randi() % creeps.CREEPS.size()
	var creep = creeps.CREEPS[creep_idx].instance()
	creep.offset = Vector2(-40 + randi() % 81, -30 + randi() % 61)
	creep.position = spawner.position + creep.offset
	creeps.add_child(creep)
