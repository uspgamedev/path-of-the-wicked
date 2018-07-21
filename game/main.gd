extends Node2D

onready var map = get_node('MapGenerator')
onready var creeps = get_node('Creeps')

var creep_spawners = []
var cursor = null

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func _ready():
	for child in map.get_children():
		if child.name.begins_with('CreepSpawner'):
			creep_spawners.append(child)

func get_hud():
	return get_node('Camera2D/HUD')

func get_panel():
	return get_node('Camera2D/HUD/Panel')

func spawn_creep(spawner): # called from MapGenerator/CreepSpawner
	randomize()
	var creep_idx = randi() % creeps.CREEPS.size()
	var creep = creeps.CREEPS[creep_idx].instance()
	creep.position = spawner.position
	creeps.add_child(creep)
