extends Node2D

onready var map = get_node('MapGenerator')
onready var creeps = get_node('Creeps')

var enemy_spawners = []

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func _ready():
	for child in map.get_children():
		if child.name.begins_with('EnemySpawner'):
			enemy_spawners.append(child)

func spawn_enemy(spawner): # called from MapGenerator/EnemySpawner
	var enemy_idx = randi() % creeps.CREEPS.size()
	var enemy = creeps.CREEPS[enemy_idx].instance()
	enemy.position = spawner.position
	creeps.add_child(enemy)
