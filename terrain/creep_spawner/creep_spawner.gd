extends Node2D

onready var map = get_node('/root/Global').get_main().get_node('MapGenerator')

var path = PoolVector2Array([])

func _ready():
	var point_path = map.a_star.get_point_path(map.idx_dict[self.position], map.idx_dict[map.base])
	for i in range(point_path.size()):
		path.append(Vector2(point_path[i].x, point_path[i].y))

func get_next_point(position):
	for i in range(path.size()):
		if position == path[i]:
			return path[i + 1]
