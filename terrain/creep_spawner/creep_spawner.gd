extends Node2D

onready var map = get_node('/root/Main/Map')

func _ready():
	get_node('Timer').wait_time = 2

func get_next_point(pos, creep):
	if pos in creep.spawn_path:
		creep.path = null
		for i in range(creep.spawn_path.size()):
			if pos == creep.spawn_path[i]:
				return creep.spawn_path[i + 1]
	if creep.path == null or creep.path_hash != hash(creep.spawn_path):
		creep.path_hash = hash(creep.spawn_path)
		var closest_point
		var dist = INF
		for point in creep.spawn_path:
			if pos.distance_to(point) < dist:
				closest_point = point
		creep.path = map.update_path(creep.spawn_AStar, creep.path, pos, closest_point)
	for i in range(creep.path.size()):
		if pos == creep.path[i]:
			return creep.path[i + 1]
