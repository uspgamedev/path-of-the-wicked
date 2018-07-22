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

onready var creep_spawners = get_node('../CreepSpawners')
onready var tilemap = get_node('TileMap')
var dict = {} # {Vector2 : PoolVector2Array}
var offset
var num_spawners = 0

func _ready():
	offset = Vector2(tilemap.cell_size.x / 2, \
	         tilemap.cell_size.y * 5/8 + tilemap.cell_quadrant_size / 2 + tilemap.position.y)
	for cell in tilemap.get_used_cells():
		if tilemap.get_cellv(cell) != GRASS:
			dict[tilemap.map_to_world(cell) + offset] = get_adj_cells(cell)

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

func add_adj_cell(cur_cell, ARRAY, next_cell, adj_cells):
	var next_cell_tile = tilemap.get_cellv(next_cell)
	if tilemap.get_cellv(cur_cell) in ARRAY and next_cell_tile != GRASS:
		if next_cell_tile != NONE:
			adj_cells.append(tilemap.map_to_world(next_cell) + offset)
		else:
			var creep_spawner = CREEP_SPAWNER.instance()
			num_spawners += 1
			creep_spawner.name = 'CreepSpawner' + str(num_spawners)
			creep_spawner.position = tilemap.map_to_world(next_cell) + offset
			creep_spawners.add_child(creep_spawner)
			dict[tilemap.map_to_world(next_cell) + offset] = \
			     PoolVector2Array([tilemap.map_to_world(cur_cell) + offset])
	return adj_cells
