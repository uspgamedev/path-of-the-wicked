extends Node2D

onready var map = get_node('/root/Main/Map')

var path

func _ready():
	path = update_path(path, self.position, map.base)
	get_node('Timer').wait_time = .2

func update_path(_path, init_pos, end_pos):
	_path = PoolVector2Array([])
	var point_path = map.a_star.get_point_path(map.idx_dict[init_pos], map.idx_dict[end_pos])
	for i in range(point_path.size()):
		_path.append(Vector2(point_path[i].x, point_path[i].y))
	return _path

func get_next_point(pos, creep):
	if pos in path:
		creep.path = null
		for i in range(path.size()):
			if pos == path[i]:
				return path[i + 1]
	if creep.path == null or creep.global_path != hash(path):
		creep.global_path = hash(path)
		var closest_point
		var dist = INF
		for point in path:
			if pos.distance_to(point) < dist:
				closest_point = point
		creep.path = update_path(creep.path, pos, closest_point)
	for i in range(creep.path.size()):
		if pos == creep.path[i]:
			return creep.path[i + 1]
