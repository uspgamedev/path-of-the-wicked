extends Node2D

const CREEP_SPAWNER = preload('res://terrain/creep_spawner/creep_spawner.tscn')
const TOWER_PH = preload('res://tower/tower_placeholder.tscn')
const TOWER = preload('res://tower/tower.tscn')
const TS_DB = preload('res://terrain/tiles/tileset_db.gd')

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
onready var tower_phs = get_node('TowerPlaceholders')
onready var ts_db = TS_DB.new()
onready var a_star = AStar.new()

var adj_cells_dict = {}
var idx_dict = {}
var grass_coord = []
var offset
var base
var in_tile_dir
var bias

func _ready():
	offset = Vector2(tilemap.cell_size.x / 2, \
		tilemap.cell_size.y * 5/8 + tilemap.cell_quadrant_size / 2 + tilemap.position.y)
	randomize()
	bias = 3*randf() - 2
	generate_procedural_map()

func generate_procedural_map():
	for i in range(-1, 15):
		for j in range(-1, 11):
			tilemap.set_cellv(Vector2(i, j), ts_db.GRASS)
	tilemap.set_cellv(Vector2(0, -1), ts_db.DR_UL)
	in_tile_dir = UP_LEFT
	var cell = Vector2(1, 0)
	while in_tile_dir != null:
		cell = generate_tile(cell)

func generate_tile(cell):
	var base_pos = tilemap.map_to_world(Vector2(13, 9))
	var length = (base_pos - tilemap.map_to_world(cell)).length() / (4 * OS.window_size.length())
	var angle = (base_pos - tilemap.map_to_world(cell)).angle_to(Vector2(1, 0))
	var rand = gaussian(bias, length)
	var target_vector = Vector2(1, 0).rotated(angle).rotated(rand)
	var out_tile_dir = get_next_tile_direction(target_vector)
	if cell.y < 0 or cell.y > 8 or cell.x < 1 or cell.x > 12:
		out_tile_dir = get_next_tile_direction(Vector2(1, 0).rotated(angle))
		bias *= -1.0/2.0
	if tilemap.get_cellv(cell) == ts_db.GRASS:
		tilemap.set_cellv(cell, ts_db.get_tile_id(self, in_tile_dir, out_tile_dir))
		cell = update_cell(cell, out_tile_dir)
	else:
		in_tile_dir = null
		bias = 0
		generate_procedural_map()
		return cell
	if cell == Vector2(13, 9):
		in_tile_dir = null
		generate_AStar_graph()
	else:
		update_in_tile_dir(out_tile_dir)
	return cell

func update_in_tile_dir(out_tile_dir):
	if out_tile_dir == LEFT:
		in_tile_dir = RIGHT
	elif out_tile_dir == DOWN_LEFT:
		in_tile_dir = UP_RIGHT
	elif out_tile_dir == DOWN_RIGHT:
		in_tile_dir = UP_LEFT
	elif out_tile_dir == RIGHT:
		in_tile_dir = LEFT
	elif out_tile_dir == UP_RIGHT:
		in_tile_dir = DOWN_LEFT
	elif out_tile_dir == UP_LEFT:
		in_tile_dir = DOWN_RIGHT

func update_cell(cell, out_tile_dir):
	if out_tile_dir == LEFT:
		return Vector2(cell.x - 1, cell.y)
	if out_tile_dir == DOWN_LEFT:
		return Vector2(cell.x - int(abs(cell.y) + 1) % 2, cell.y + 1)
	if out_tile_dir == DOWN_RIGHT:
		return Vector2(cell.x + int(abs(cell.y)) % 2, cell.y + 1)
	if out_tile_dir == RIGHT:
		return Vector2(cell.x + 1, cell.y)
	if out_tile_dir == UP_RIGHT:
		return Vector2(cell.x + int(abs(cell.y)) % 2, cell.y - 1)
	if out_tile_dir == UP_LEFT:
		return Vector2(cell.x - int(abs(cell.y) + 1) % 2, cell.y - 1)

func get_angle_vector(target_vector):
	var angles = []
	if in_tile_dir != LEFT:
		angles.append(target_vector.angle_to(LEFT))
	if in_tile_dir != DOWN_LEFT:
		angles.append(target_vector.angle_to(DOWN_LEFT))
	if in_tile_dir != DOWN_RIGHT:
		angles.append(target_vector.angle_to(DOWN_RIGHT))
	if in_tile_dir != RIGHT:
		angles.append(target_vector.angle_to(RIGHT))
	if in_tile_dir != UP_RIGHT:
		angles.append(target_vector.angle_to(UP_RIGHT))
	if in_tile_dir != UP_LEFT:
		angles.append(target_vector.angle_to(UP_LEFT))
	return angles

func get_next_tile_direction(target_vector):
	var angles = get_angle_vector(target_vector)
	var min_angle = INF
	for angle in angles:
		if abs(angle) < min_angle:
			min_angle = abs(angle)
	if min_angle == abs(target_vector.angle_to(LEFT)):
		return LEFT
	if min_angle == abs(target_vector.angle_to(DOWN_LEFT)):
		return DOWN_LEFT
	if min_angle == abs(target_vector.angle_to(DOWN_RIGHT)):
		return DOWN_RIGHT
	if min_angle == abs(target_vector.angle_to(RIGHT)):
		return RIGHT
	if min_angle == abs(target_vector.angle_to(UP_RIGHT)):
		return UP_RIGHT
	if min_angle == abs(target_vector.angle_to(UP_LEFT)):
		return UP_LEFT

func gaussian(mean, deviation):
	var x1
	var x2
	var w
	while true:
		randomize()
		x1 = rand_range(0, 2) - 1
		x2 = rand_range(0, 2) - 1
		w = x1*x1 + x2*x2
		if 0 < w and w < 1:
			break
	w = sqrt(-2 * log(w)/w)
	return mean + deviation * x1 * w

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
			a_star.connect_points(idx_dict[key], idx_dict[value], false)
	create_tower_placeholders()

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
	var idx = a_star.get_available_point_id()
	a_star.add_point(idx, Vector3(_pos.x, _pos.y, 0))
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
				spawner_manager.add_child(creep_spawner)
				adj_cells_dict[pos] = PoolVector2Array([tilemap.map_to_world(cur_cell) + offset])
				_add_point(pos)
		else:
			base = pos
			adj_cells.append(pos)
			_add_point(pos)
	return adj_cells

func create_tower_placeholders():
	for pos in grass_coord:
		var tower_ph = TOWER_PH.instance()
		tower_ph.position = pos
		tower_ph.visible = false
		tower_phs.add_child(tower_ph)

func _input(event):
	if event.is_action_pressed('ui_buy_tower'):
		show_tower_phs()

func show_tower_phs():
	for tower_ph in tower_phs.get_children():
		tower_ph.visible = true

func hide_tower_phs():
	for tower_ph in tower_phs.get_children():
		tower_ph.visible = false

func place_tower(pos):
	var tower = TOWER.instance()
	tower.position = pos
	towers.add_child(tower)
	hud.update_gold(-tower.price)
	tower.draw_circle = true
	tower.update()
	hide_tower_phs()
