extends Node2D

onready var map = get_node('/root/Main/Map')

func _ready():
	get_node('Timer').wait_time = 2

func get_next_point(pos, creep):
	if creep.spawn_path.size() == 0:
		creep.spawn_path = map.update_path(creep.spawn_AStar, creep.spawn_path, creep.spawner.position, map.base)
		map.a_star.set_spawn_path(map, creep)
	if pos in creep.spawn_path:
		creep.path = null
		for i in range(creep.spawn_path.size()):
			if pos == creep.spawn_path[i]:
				return creep.spawn_path[i + 1]
	if creep.path == null:
		creep.path = map.update_path(creep.spawn_AStar, creep.path, pos, map.base)
	for i in range(creep.path.size()):
		if pos == creep.path[i]:
			return creep.path[i + 1]
