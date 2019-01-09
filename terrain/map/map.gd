extends Node2D

const CREEP_SPAWNER = preload('res://terrain/creep_spawner/creep_spawner.tscn')
const DUMMY_TOWER = preload('res://tower/dummy_tower.tscn')
const TOWER = preload('res://tower/tower.tscn')
const TS_DB = preload('res://terrain/tiles/tileset_db.gd')
const A_STAR = preload('res://terrain/map/a_star_db.gd')

var LEFT =       Vector2(1, 0).rotated(-PI)
var DOWN_LEFT =  Vector2(1, 0).rotated(-2*PI/3)
var DOWN_RIGHT = Vector2(1, 0).rotated(-PI/3)
var RIGHT =      Vector2(1, 0).rotated(0)
var UP_RIGHT =   Vector2(1, 0).rotated(PI/3)
var UP_LEFT =    Vector2(1, 0).rotated(2*PI/3)

onready var hud = get_node('../Camera2D/HUD')
onready var spawner_manager = get_node('../SpawnerManager')
onready var towers = get_node('../Towers')
onready var tilemap = get_node('TileMap')
onready var dummy_towers = get_node('DummyTowers')
onready var ts_db = TS_DB.new()
onready var a_star = A_STAR.new()

var map_complexity = 0.4
var min_path_size = 4
var is_dummy_towers_visible = false
var adj_cells_dict = {}
var idx_dict = {}
var grass_coord = []
var spawner_pos = []
var offset
var base
var base_tile
var initial_path = false
var path_pos = []
var path_id = []
var valid_cells = []
var invalid_cells = []

func _ready():
	rand_seed(OS.get_system_time_secs())
	offset = Vector2(tilemap.cell_size.x / 2, tilemap.cell_size.y * 5/8 + \
			tilemap.cell_quadrant_size / 2 + tilemap.position.y)
	base_tile = tilemap.map_to_world(Vector2(13, 9))
	a_star.init(self)
	generate_procedural_map()
#	generate_AStar_graph()
	a_star.ready(self)

func generate_procedural_map():
	for i in range(-1, 16):
		for j in range(-1, 11):
			tilemap.set_cellv(Vector2(i, j), ts_db.GRASS)
	generate_initial_path(Vector2(0, -1), ts_db.DR_UL, Vector2(1, 0), UP_LEFT, 0.7)
	generate_initial_path(Vector2(-1, 7), ts_db.L_R, Vector2(0, 7), LEFT, 0.3)
	for used_cell in tilemap.get_used_cells():
		if tilemap.get_cellv(used_cell) != ts_db.GRASS and not tilemap.get_cellv(used_cell) in ts_db.BRANCHED_TILE:
				if used_cell.y >= 0 and used_cell.y <= 9 and used_cell.x >= 0 and used_cell.x <= 13:
					valid_cells.append(used_cell)
	while valid_cells.size() > 0:
		var path_cells = []
		for cell in tilemap.get_used_cells():
			if tilemap.get_cellv(cell) != ts_db.GRASS:
				path_cells.append(cell)
		if (float(path_cells.size()) / tilemap.get_used_cells().size()) > map_complexity:
			break
		randomize()
		var rand_idx = randi() % valid_cells.size()
		for cell in valid_cells:
			if tilemap.get_cellv(valid_cells[rand_idx]) in ts_db.BRANCHED_TILE:
				valid_cells.erase(cell)
		generate_middle_path(valid_cells[rand_idx])
	valid_cells.clear()
	generate_AStar_graph()
#	yield(get_tree(), 'physics_frame')
#	yield(get_tree().create_timer(1.0), 'timeout')
#	generate_procedural_map()

func generate_initial_path(creep_spawner, cell_id, cell, in_tile_dir, bias):
	var info
	var reset = [cell, in_tile_dir]
	tilemap.set_cellv(creep_spawner, cell_id)
	initial_path = true
	while cell != null:
		info = generate_tile(cell, bias, in_tile_dir)
		cell = info[0]
		in_tile_dir = info[1]
	path_pos.clear()
	path_id.clear()
	if initial_path == true:
		generate_initial_path(creep_spawner, cell_id, reset[0], reset[1], bias)

func generate_middle_path(cell):
	var out_tile_dir = ts_db.get_random_dir(self, cell, tilemap.get_cellv(cell))
	if out_tile_dir == null:
		valid_cells.erase(cell)
		return
	path_pos.append(cell)
	path_id.append(tilemap.get_cellv(cell))
	invalid_cells.append(cell)
	tilemap.set_cellv(cell, branch(tilemap.get_cellv(cell), out_tile_dir))
	cell = get_cell(cell, out_tile_dir)
	var info
	var in_tile_dir = get_in_tile_dir(out_tile_dir)
	randomize()
	var bias = (0.2 + 1.8*randf()) * (-1 + 2 *(randi() % 2))
	while cell != null:
		info = generate_tile(cell, bias, in_tile_dir)
		cell = info[0]
		in_tile_dir = info[1]
	if path_pos.size() > min_path_size:
		for cell in invalid_cells:
			valid_cells.erase(cell)
		invalid_cells.clear()
		for cell in path_pos:
			if not tilemap.get_cellv(cell) in ts_db.BRANCHED_TILE:
				if tilemap.get_cellv(cell) != ts_db.GRASS:
					valid_cells.append(cell)
	else:
		reset_path()
	path_pos.clear()
	path_id.clear()

func generate_tile(cell, bias, in_tile_dir):
	var length = (base_tile - tilemap.map_to_world(cell)).length() / 3000
	if length < 0.1:
		length = 0
	var angle = (base_tile - tilemap.map_to_world(cell)).angle_to(Vector2(1, 0))
	var rand = gaussian(bias, length)
	var target_vector = Vector2(1, 0).rotated(angle).rotated(rand)
	var out_tile_dir = get_next_tile_direction(cell, in_tile_dir, target_vector)
	if cell.y < 0 or cell.y >= 9 or cell.x < 0 or cell.x >= 13:
		out_tile_dir = get_next_tile_direction(cell, in_tile_dir, Vector2(1, 0).rotated(angle))
	if tilemap.get_cellv(cell) == ts_db.GRASS:
		path_pos.append(cell)
		path_id.append(ts_db.GRASS)
		tilemap.set_cellv(cell, ts_db.get_tile_id(self, in_tile_dir, out_tile_dir))
	else:
		if tilemap.get_cellv(cell) in ts_db.BRANCHED_TILE or cell in path_pos:
			reset_path()
		else:
			path_pos.append(cell)
			path_id.append(tilemap.get_cellv(cell))
			invalid_cells.append(cell)
			tilemap.set_cellv(cell, branch(tilemap.get_cellv(cell), in_tile_dir))
			initial_path = false
		return [null, null]
	cell = get_cell(cell, out_tile_dir)
	if cell == Vector2(13, 9):
		initial_path = false
		return [null, null]
	else:
		return [cell, get_in_tile_dir(out_tile_dir)]

func reset_path():
	for i in range(path_pos.size()):
		tilemap.set_cellv(path_pos[i], path_id[i])
		if path_pos[i] in valid_cells and path_id[i] == ts_db.GRASS:
			valid_cells.erase(path_pos[i])
	invalid_cells.clear()

func branch(cell, in_tile_dir):
	cell = ts_db.get_dir_strings(cell)
	match in_tile_dir:
		LEFT:       in_tile_dir = 'L'
		DOWN_LEFT:  in_tile_dir = 'DL'
		DOWN_RIGHT: in_tile_dir = 'DR'
		RIGHT:      in_tile_dir = 'R'
		UP_RIGHT:   in_tile_dir = 'UR'
		UP_LEFT:    in_tile_dir = 'UL'
	return get_matching_cell(cell, in_tile_dir)

func get_matching_cell(cell, in_tile_dir):
	cell.append(in_tile_dir)
	cell.sort()
	cell = str(cell[0], '_', cell[1], '_', cell[2])
	return ts_db.get(cell)

func get_in_tile_dir(out_tile_dir):
	match out_tile_dir:
		LEFT:       return RIGHT
		DOWN_LEFT:  return UP_RIGHT
		DOWN_RIGHT: return UP_LEFT
		RIGHT:      return LEFT
		UP_RIGHT:   return DOWN_LEFT
		UP_LEFT:    return DOWN_RIGHT

func get_cell(cell, out_tile_dir):
	match out_tile_dir:
		LEFT:       return Vector2(cell.x - 1, cell.y)
		DOWN_LEFT:  return Vector2(cell.x - int(abs(cell.y) + 1) % 2, cell.y + 1)
		DOWN_RIGHT: return Vector2(cell.x + int(abs(cell.y)) % 2, cell.y + 1)
		RIGHT:      return Vector2(cell.x + 1, cell.y)
		UP_RIGHT:   return Vector2(cell.x + int(abs(cell.y)) % 2, cell.y - 1)
		UP_LEFT:    return Vector2(cell.x - int(abs(cell.y) + 1) % 2, cell.y - 1)

func get_angle_vector(cell, in_tile_dir, target_vector):
	var angles = []
	var even = int(cell.y + 1) % 2
	if in_tile_dir != LEFT and cell.x > 0:
		angles.append(target_vector.angle_to(LEFT))
	if in_tile_dir != DOWN_LEFT and (cell.x > 0 or (cell.x == 0 and not even)) and cell.y < 9:
		angles.append(target_vector.angle_to(DOWN_LEFT))
	if in_tile_dir != DOWN_RIGHT and (cell.x < 13 or (cell.x == 13 and even)) and cell.y < 9:
		angles.append(target_vector.angle_to(DOWN_RIGHT))
	if in_tile_dir != RIGHT and cell.x < 13:
		angles.append(target_vector.angle_to(RIGHT))
	if in_tile_dir != UP_RIGHT and (cell.x < 13 or (cell.x == 13 and even)) and cell.y > 0:
		angles.append(target_vector.angle_to(UP_RIGHT))
	if in_tile_dir != UP_LEFT and (cell.x > 0 or (cell.x == 0 and not even)) and cell.y > 0:
		angles.append(target_vector.angle_to(UP_LEFT))
	return angles

func get_next_tile_direction(cell, in_tile_dir, target_vector):
	var angles = get_angle_vector(cell, in_tile_dir, target_vector)
	var min_angle = INF
	for angle in angles:
		if abs(angle) < abs(min_angle):
			min_angle = angle
	if min_angle == target_vector.angle_to(LEFT):
		return LEFT
	if min_angle == target_vector.angle_to(DOWN_LEFT):
		return DOWN_LEFT
	if min_angle == target_vector.angle_to(DOWN_RIGHT):
		return DOWN_RIGHT
	if min_angle == target_vector.angle_to(RIGHT):
		return RIGHT
	if min_angle == target_vector.angle_to(UP_RIGHT):
		return UP_RIGHT
	if min_angle == target_vector.angle_to(UP_LEFT):
		return UP_LEFT

func gaussian(mean, deviation):
	var x1
	var x2
	var w
	if deviation == 0:
		return mean
	while true:
		randomize()
		x1 = rand_range(0, 2) - 1
		x2 = rand_range(0, 2) - 1
		w = x1*x1 + x2*x2
		if 0 < w and w < 1:
			break
	w = sqrt(-2 * log(w)/w)
	return mean + deviation * x1 * w

func update_graph_weights(tower, gem_dmg, gem_color):
	gem_dmg *= 10
	for cell in tilemap.get_used_cells():
		if tilemap.get_cellv(cell) != ts_db.GRASS:
			var cell_pos = tilemap.map_to_world(cell) + offset
			if cell_pos.distance_to(tower.position / self.scale.x) < \
					tower.radius / self.scale.x:
				a_star.update_weight(idx_dict[cell_pos], gem_dmg, gem_color)
	a_star.reset_spawn_paths(self)

func update_path(_a_star, path, init_pos):
	path = PoolVector2Array([])
	var point_path = _a_star.get_point_path(idx_dict[init_pos], idx_dict[base])
	for i in range(point_path.size()):
		path.append(Vector2(point_path[i].x, point_path[i].y))
	return path

func generate_AStar_graph():
	for cell in tilemap.get_used_cells():
		var pos = tilemap.map_to_world(cell) + offset
		if tilemap.get_cellv(cell) != ts_db.GRASS:
			adj_cells_dict[pos] = get_adj_cells(cell)
			_add_point(pos)
		else:
			grass_coord.append(pos)
	for key in adj_cells_dict.keys():
		for value in adj_cells_dict[key]:
			a_star._connect_points(idx_dict[key], idx_dict[value])
	create_dummy_towers()

func get_adj_cells(cell):
	var adj_cells = PoolVector2Array([])
	var even = int(cell.y + 1) % 2
	var dl = Vector2(cell.x - even, cell.y + 1)
	var dr = Vector2(cell.x - even + 1, cell.y + 1)
	var l  = Vector2(cell.x - 1, cell.y)
	var r  = Vector2(cell.x + 1, cell.y)
	var ul = Vector2(cell.x - even, cell.y - 1)
	var ur = Vector2(cell.x - even + 1, cell.y - 1)
	adj_cells = add_adj_cell(cell, ts_db.DL, dl, adj_cells)
	adj_cells = add_adj_cell(cell, ts_db.DR, dr, adj_cells)
	adj_cells = add_adj_cell(cell,  ts_db.L,  l, adj_cells)
	adj_cells = add_adj_cell(cell,  ts_db.R,  r, adj_cells)
	adj_cells = add_adj_cell(cell, ts_db.UL, ul, adj_cells)
	adj_cells = add_adj_cell(cell, ts_db.UR, ur, adj_cells)
	return adj_cells

func _add_point(_pos):
	var idx = a_star._get_available_point_id()
	a_star._add_point(idx, Vector3(_pos.x, _pos.y, 0))
	idx_dict[_pos] = idx

func add_adj_cell(cur_cell, ARRAY, next_cell, adj_cells):
	var next_cell_tile = tilemap.get_cellv(next_cell)
	var pos = tilemap.map_to_world(next_cell) + offset
	if tilemap.get_cellv(cur_cell) in ARRAY:
		if next_cell_tile != ts_db.GRASS:
			if next_cell_tile != ts_db.NONE:
				adj_cells.append(pos)
			else:
				var creep_spawner = CREEP_SPAWNER.instance()
				creep_spawner.position = pos
				spawner_pos.append(pos)
				spawner_manager.add_child(creep_spawner)
				adj_cells_dict[pos] = PoolVector2Array([tilemap.map_to_world(cur_cell) + offset])
				_add_point(pos)
		else:
			base = pos
			adj_cells.append(pos)
			_add_point(pos)
	return adj_cells

func create_dummy_towers():
	for pos in grass_coord:
		if pos != base and pos.x > 0 and pos.x < 3200:
			var dummy_tower = DUMMY_TOWER.instance()
			dummy_tower.position = pos
			dummy_tower.visible = false
			dummy_towers.add_child(dummy_tower)

func _input(event):
	if event.is_action_pressed('ui_buy_tower'):
		if not is_dummy_towers_visible:
			show_dummy_towers()
		else:
			hide_dummy_towers()

func show_dummy_towers():
	is_dummy_towers_visible = true
	for dummy_tower in dummy_towers.get_children():
		dummy_tower.visible = true

func hide_dummy_towers():
	is_dummy_towers_visible = false
	for dummy_tower in dummy_towers.get_children():
		dummy_tower.visible = false

func place_tower(pos):
	var tower = TOWER.instance()
	tower.position = pos
	towers.add_child(tower)
	hud.update_gold(-hud.tower_price)
	hud.tower_price += 100
	tower.update_circle_texture()
	tower.circle.visible = true
	hide_dummy_towers()
