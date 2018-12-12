extends Node

const NONE = -1

const DL = [1, 2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15]
const DR = [1, 2,  3,  4,  5, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
const L  = [2, 6,  7,  8,  9, 16, 17, 18, 19, 26, 27, 28, 29, 30, 31]
const R  = [3, 7, 10, 11, 12, 17, 20, 21, 22, 26, 27, 28, 32, 33, 34]
const UL = [4, 8, 11, 13, 14, 18, 21, 23, 24, 27, 29, 30, 32, 33, 35]
const UR = [5, 9, 12, 14, 15, 19, 22, 24, 25, 28, 30, 31, 33, 34, 35]

enum {
	GRASS,
	DL_DR,
	DL_DR_L,
	DL_DR_R,
	DL_DR_UL,
	DL_DR_UR,
	DL_L,
	DL_L_R,
	DL_L_UL,
	DL_L_UR,
	DL_R,
	DL_R_UL,
	DL_R_UR,
	DL_UL,
	DL_UL_UR,
	DL_UR,
	DR_L,
	DR_L_R,
	DR_L_UL,
	DR_L_UR,
	DR_R,
	DR_R_UL,
	DR_R_UR,
	DR_UL,
	DR_UL_UR,
	DR_UR,
	L_R,
	L_R_UL,
	L_R_UR,
	L_UL,
	L_UL_UR,
	L_UR,
	R_UL,
	R_UL_UR,
	R_UR,
	UL_UR
}

const BRANCHED_TILE = [
	DL_DR_L,
	DL_DR_R,
	DL_DR_UL,
	DL_DR_UR,
	DL_L_R,
	DL_L_UL,
	DL_L_UR,
	DL_R_UL,
	DL_R_UR,
	DL_UL_UR,
	DR_L_R,
	DR_L_UL,
	DR_L_UR,
	DR_R_UL,
	DR_R_UR,
	DR_UL_UR,
	L_R_UL,
	L_R_UR,
	L_UL_UR,
	R_UL_UR
]

func get_matching_cell(cell, in_tile_dir):
	cell.append(in_tile_dir)
	cell.sort()
	cell = str(cell[0], '_', cell[1], '_', cell[2])
	return get(cell)

func branch(map, cell, in_tile_dir):
	match cell:
		DL_DR: cell = ['DL', 'DR']
		DL_L:  cell = ['DL', 'L']
		DL_R:  cell = ['DL', 'R']
		DL_UL: cell = ['DL', 'UL']
		DL_UR: cell = ['DL', 'UR']
		DR_L:  cell = ['DR', 'L']
		DR_R:  cell = ['DR', 'R']
		DR_UL: cell = ['DR', 'UL']
		DR_UR: cell = ['DR', 'UR']
		L_R:   cell = ['L', 'R']
		L_UL:  cell = ['L', 'UL']
		L_UR:  cell = ['L', 'UR']
		R_UL:  cell = ['R', 'UL']
		R_UR:  cell = ['R', 'UR']
		UL_UR: cell = ['UL', 'UR']
	match in_tile_dir:
		map.LEFT:       in_tile_dir = 'L'
		map.DOWN_LEFT:  in_tile_dir = 'DL'
		map.DOWN_RIGHT: in_tile_dir = 'DR'
		map.RIGHT:      in_tile_dir = 'R'
		map.UP_RIGHT:   in_tile_dir = 'UR'
		map.UP_LEFT:    in_tile_dir = 'UL'
	return get_matching_cell(cell, in_tile_dir)

func get_tile_id(map, in_tile_dir, out_tile_dir):
	var dir = [in_tile_dir, out_tile_dir]
	if map.DOWN_LEFT in dir and map.DOWN_RIGHT in dir:
		return DL_DR
	if map.DOWN_LEFT in dir and map.LEFT in dir:
		return DL_L
	if map.DOWN_LEFT in dir and map.RIGHT in dir:
		return DL_R
	if map.DOWN_LEFT in dir and map.UP_LEFT in dir:
		return DL_UL
	if map.DOWN_LEFT in dir and map.UP_RIGHT in dir:
		return DL_UR
	if map.DOWN_RIGHT in dir and map.LEFT in dir:
		return DR_L
	if map.DOWN_RIGHT in dir and map.RIGHT in dir:
		return DR_R
	if map.DOWN_RIGHT in dir and map.UP_LEFT in dir:
		return DR_UL
	if map.DOWN_RIGHT in dir and map.UP_RIGHT in dir:
		return DR_UR
	if map.LEFT in dir and map.RIGHT in dir:
		return L_R
	if map.LEFT in dir and map.UP_LEFT in dir:
		return L_UL
	if map.LEFT in dir and map.UP_RIGHT in dir:
		return L_UR
	if map.RIGHT in dir and map.UP_LEFT in dir:
		return R_UL
	if map.RIGHT in dir and map.UP_RIGHT in dir:
		return R_UR
	if map.UP_LEFT in dir and map.UP_RIGHT in dir:
		return UL_UR
