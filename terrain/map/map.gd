extends Node2D

const GRASS = 0
const NONE = -1
const DL = [1, 2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15]
const DR = [1, 2,  3,  4,  5, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
const L  = [2, 6,  7,  8,  9, 16, 17, 18, 19, 26, 27, 28, 29, 30, 31]
const R  = [3, 7, 10, 11, 12, 17, 20, 21, 22, 26, 27, 28, 32, 33, 34]
const UL = [4, 8, 11, 13, 14, 18, 21, 23, 24, 27, 29, 30, 32, 33, 35]
const UR = [5, 9, 12, 14, 15, 19, 22, 24, 25, 28, 30, 31, 33, 34, 35]

const CREEP_SPAWNER = preload('res://terrain/creep_spawner/creep_spawner.tscn')
const TOWER_PH = preload('res://tower/tower_placeholder.tscn')
const TOWER = preload('res://tower/tower.tscn')

onready var hud = get_node('../Camera2D/HUD')
onready var spawner_manager = get_node('../SpawnerManager')
onready var towers = get_node('../Towers')
onready var tilemap = get_node('TileMap')
onready var tower_phs = get_node('TowerPlaceholders')
onready var a_star = AStar.new()

var adj_cells_dict = {} # {Vector2 : PoolVector2Array}
var idx_dict = {} # {Vector2 : int}
var grass_coord = []
var offset
var base

func _ready():
	offset = Vector2(tilemap.cell_size.x / 2, \
	         tilemap.cell_size.y * 5/8 + tilemap.cell_quadrant_size / 2 + tilemap.position.y)
	for cell in tilemap.get_used_cells():
		var pos = tilemap.map_to_world(cell) + offset
		if tilemap.get_cellv(cell) != GRASS:
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
	adj_cells = add_adj_cell(cell, DL, dl, adj_cells)
	adj_cells = add_adj_cell(cell, DR, dr, adj_cells)
	adj_cells = add_adj_cell(cell,  L,  l, adj_cells)
	adj_cells = add_adj_cell(cell,  R,  r, adj_cells)
	adj_cells = add_adj_cell(cell, UL, ul, adj_cells)
	adj_cells = add_adj_cell(cell, UR, ur, adj_cells)
	return adj_cells

func _add_point(_pos):
	var idx = a_star.get_available_point_id()
	a_star.add_point(idx, Vector3(_pos.x, _pos.y, 0))
	idx_dict[_pos] = idx

func add_adj_cell(cur_cell, ARRAY, next_cell, adj_cells):
	var next_cell_tile = tilemap.get_cellv(next_cell)
	var pos = tilemap.map_to_world(next_cell) + offset
	if tilemap.get_cellv(cur_cell) in ARRAY:
		if next_cell_tile != GRASS:
			if next_cell_tile != NONE:
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
	hud.update_gold(-tower.cost)
	tower.draw_circle = true
	tower.update()
	hide_tower_phs()
