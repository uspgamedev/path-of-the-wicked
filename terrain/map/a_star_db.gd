extends Node

const CREEP_INFO = preload('res://creeps/creep_info.gd')

const A_STAR = 0

var point_id = 0
var creep_info
var graphs = {}

func init(map):
	creep_info = CREEP_INFO.new()
	for creep_name in creep_info.INFO.keys():
		var value = [AStar.new()]
		graphs[creep_name] = value

func ready(map):
	for key in graphs.keys():
		for i in map.spawner_pos.size():
			var value = graphs[key]
			value.append(PoolVector2Array([]))
			graphs[key] = value

func _get_available_point_id():
	point_id += 1
	return point_id

func _add_point(id, position):
	for graph in graphs.values():
		graph[A_STAR].add_point(id, position)

func _connect_points(id, to_id):
	for graph in graphs.values():
		graph[A_STAR].connect_points(id, to_id, false)

func update_graph_paths(map):
	for key in graphs.keys():
		var graph = graphs[key]
		var value = [graph[A_STAR]]
		for i in map.spawner_pos.size():
			value.append(map.update_path(graph[A_STAR], graph[i+1], map.spawner_pos[i], map.base))
		graphs[key] = value
	var creeps = map.get_node('../Creeps')
	for creep in creeps.get_children():
		if creep.is_in_group('creep'):
			creep.spawn_path = get_spawn_path(map, creep.name, creep.spawner.position)

func update_weight(cell_id, gem_dmg, gem_color):
	var weight
	for key in graphs.keys():
		weight = graphs[key][A_STAR].get_point_weight_scale(cell_id)
		if creep_info.get_creep_weakness(key) == gem_color:
			gem_dmg *= 2
		elif creep_info.get_creep_strength(key) == gem_color:
			gem_dmg /= 2
		graphs[key][A_STAR].set_point_weight_scale(cell_id, weight + gem_dmg)

func get_spawn_AStar(creep_name):
	return graphs[creep_name.split('-')[0]][A_STAR]

func get_spawn_path(map, creep_name, pos):
	var idx = map.spawner_pos.find(pos)
	return graphs[creep_name.split('-')[0]][idx+1]

func set_graph_path(map, creep_name, a_star, path, pos):
	var idx = map.spawner_pos.find(pos)
	var value = graphs[creep_name.split('-')[0]]
	value[idx+1] = path
	graphs[creep_name.split('-')[0]] = value
