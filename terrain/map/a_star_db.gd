extends Node

const CREEP_INFO = preload('res://creeps/creep_info.gd')

var point_id = 0
var creep_info
var graphs = {}
var paths = {}

func init(map):
	creep_info = CREEP_INFO.new()
	for creep_name in creep_info.INFO.keys():
		graphs[creep_name] = AStar.new()

func ready(map):
	for key in graphs.keys():
		var value = []
		for i in map.spawner_pos.size():
			value.append(PoolVector2Array([]))
		paths[key] = value

func _get_available_point_id():
	point_id += 1
	return point_id

func _add_point(id, position):
	for graph in graphs.values():
		graph.add_point(id, position)

func _connect_points(id, to_id):
	for graph in graphs.values():
		graph.connect_points(id, to_id, false)

func reset_spawn_paths(map):
	for key in paths.keys():
		var value = []
		for i in map.spawner_pos.size():
			value.append(PoolVector2Array([]))
		paths[key] = value
	update_creeps_spawn_path(map)

func update_creeps_spawn_path(map):
	var creeps = map.get_node('../Creeps')
	for creep in creeps.get_children():
		if creep.is_in_group('creep'):
			creep.path = null
			creep.spawn_path = get_spawn_path(map, creep.name, creep.spawner.position)

func update_weight(cell_id, gem_dmg, gem_color):
	var weight
	for key in graphs.keys():
		weight = graphs[key].get_point_weight_scale(cell_id)
		if creep_info.get_creep_weakness(key) == gem_color:
			gem_dmg *= 2
		elif creep_info.get_creep_strength(key) == gem_color:
			gem_dmg = float(gem_dmg) / 2
		graphs[key].set_point_weight_scale(cell_id, weight + gem_dmg)

func get_spawn_graph(creep_name):
	return graphs[creep_name.split('-')[0]]

func get_spawn_path(map, creep_name, pos):
	var idx = map.spawner_pos.find(pos)
	return paths[creep_name.split('-')[0]][idx]

func set_spawn_path(map, creep):
	var idx = map.spawner_pos.find(creep.spawner.position)
	var creep_name = creep.name.split('-')[0]
	var value = paths[creep_name]
	value[idx] = creep.spawn_path
	paths[creep_name] = value
	update_creeps_spawn_path(map)
