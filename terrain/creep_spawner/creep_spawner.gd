extends Node2D

onready var map = get_node('/root/Main/Map')

func _ready():
	get_node('Timer').wait_time = 2

func get_next_point(pos, creep):
	if creep.spawn_path.size() == 0:
		creep.spawn_path = map.update_path(creep.spawn_graph, \
				creep.spawn_path, creep.spawner.position)
		map.a_star.set_spawn_path(map, creep)
	if pos in creep.spawn_path:
		creep.path = null
		return find(pos, creep.spawn_path)
	if creep.path == null:
		creep.path = map.update_path(creep.spawn_graph, \
				creep.path, pos)
	return find(pos, creep.path)

func find(pos, path):
	for i in range(path.size()):
		if pos == path[i]:
			return path[i + 1]
