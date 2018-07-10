extends Node2D

const GRASS = 0
const NONE = -1
const DL = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
const DR = [1, 2, 3, 4, 5, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
const L  = [2, 6, 7, 8, 9, 16, 17, 18, 19, 26, 27, 28, 29, 30, 31]
const R  = [3, 7, 10, 11, 12, 17, 20, 21, 22, 26, 27, 28, 32, 33, 34]
const UL = [4, 8, 11, 13, 14, 18, 21, 23, 24, 27, 29, 30, 32, 33, 35]
const UR = [5, 9, 12, 14, 15, 19, 22, 24, 25, 28, 30, 31, 33, 34, 35]

onready var tilemap = get_node('TileMap')
var dict = {} # {Vector2 : PoolVector2Array}
var offset

func _ready():
	offset = Vector2(tilemap.cell_size.x / 2, \
	         tilemap.cell_size.y * 5/8 + tilemap.cell_quadrant_size / 2)
	for cell in tilemap.get_used_cells():
		if tilemap.get_cellv(cell) != GRASS:
			dict[tilemap.map_to_world(cell) + offset] = get_adj_cells(cell)

func get_adj_cells(cell):
	var adj_cells = PoolVector2Array([])
	var dl = Vector2(cell.x, cell.y + 1)
	var dr = Vector2(cell.x + 1, cell.y + 1)
	var l  = Vector2(cell.x - 1, cell.y)
	var r  = Vector2(cell.x + 1, cell.y)
	var ul = Vector2(cell.x, cell.y - 1)
	var ur = Vector2(cell.x + 1, cell.y + 1)
	var tile = tilemap.get_cellv(cell)
	if tile in DL and tilemap.get_cellv(dl) != NONE:
		adj_cells.append(tilemap.map_to_world(dl) + offset)
	if tile in DR and tilemap.get_cellv(dr) != NONE:
		adj_cells.append(tilemap.map_to_world(dr) + offset)
	if tile in L  and tilemap.get_cellv(l)  != NONE:
		adj_cells.append(tilemap.map_to_world(l)  + offset)
	if tile in R  and tilemap.get_cellv(r)  != NONE:
		adj_cells.append(tilemap.map_to_world(r)  + offset)
	if tile in UL and tilemap.get_cellv(ul) != NONE:
		adj_cells.append(tilemap.map_to_world(ul) + offset)
	if tile in UR and tilemap.get_cellv(ur) != NONE:
		adj_cells.append(tilemap.map_to_world(ur) + offset)
	return adj_cells
	