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
	L_R_UR
	L_UL,
	L_UL_UR,
	L_UR,
	R_UL,
	R_UL_UR,
	R_UR,
	UL_UR
}

func get_tile_id(map, in_tile_dir, out_tile_dir):
	if (in_tile_dir == map.DOWN_LEFT and out_tile_dir == map.DOWN_RIGHT) or \
	   (out_tile_dir == map.DOWN_LEFT and in_tile_dir == map.DOWN_RIGHT):
		return DL_DR
	if (in_tile_dir == map.DOWN_LEFT and out_tile_dir == map.LEFT) or \
	   (out_tile_dir == map.DOWN_LEFT and in_tile_dir == map.LEFT):
		return DL_L
	if (in_tile_dir == map.DOWN_LEFT and out_tile_dir == map.RIGHT) or \
	   (out_tile_dir == map.DOWN_LEFT and in_tile_dir == map.RIGHT):
		return DL_R
	if (in_tile_dir == map.DOWN_LEFT and out_tile_dir == map.UP_LEFT) or \
	   (out_tile_dir == map.DOWN_LEFT and in_tile_dir == map.UP_LEFT):
		return DL_UL
	if (in_tile_dir == map.DOWN_LEFT and out_tile_dir == map.UP_RIGHT) or \
	   (out_tile_dir == map.DOWN_LEFT and in_tile_dir == map.UP_RIGHT):
		return DL_UR
	if (in_tile_dir == map.DOWN_RIGHT and out_tile_dir == map.LEFT) or \
	   (out_tile_dir == map.DOWN_RIGHT and in_tile_dir == map.LEFT):
		return DR_L
	if (in_tile_dir == map.DOWN_RIGHT and out_tile_dir == map.RIGHT) or \
	   (out_tile_dir == map.DOWN_RIGHT and in_tile_dir == map.RIGHT):
		return DR_R
	if (in_tile_dir == map.DOWN_RIGHT and out_tile_dir == map.UP_LEFT) or \
	   (out_tile_dir == map.DOWN_RIGHT and in_tile_dir == map.UP_LEFT):
		return DR_UL
	if (in_tile_dir == map.DOWN_RIGHT and out_tile_dir == map.UP_RIGHT) or \
	   (out_tile_dir == map.DOWN_RIGHT and in_tile_dir == map.UP_RIGHT):
		return DR_UR
	if (in_tile_dir == map.LEFT and out_tile_dir == map.RIGHT) or \
	   (out_tile_dir == map.LEFT and in_tile_dir == map.RIGHT):
		return L_R
	if (in_tile_dir == map.LEFT and out_tile_dir == map.UP_LEFT) or \
	   (out_tile_dir == map.LEFT and in_tile_dir == map.UP_LEFT):
		return L_UL
	if (in_tile_dir == map.LEFT and out_tile_dir == map.UP_RIGHT) or \
	   (out_tile_dir == map.LEFT and in_tile_dir == map.UP_RIGHT):
		return L_UR
	if (in_tile_dir == map.RIGHT and out_tile_dir == map.UP_LEFT) or \
	   (out_tile_dir == map.RIGHT and in_tile_dir == map.UP_LEFT):
		return R_UL
	if (in_tile_dir == map.RIGHT and out_tile_dir == map.UP_RIGHT) or \
	   (out_tile_dir == map.RIGHT and in_tile_dir == map.UP_RIGHT):
		return R_UR
	if (in_tile_dir == map.UP_LEFT and out_tile_dir == map.UP_RIGHT) or \
	   (out_tile_dir == map.UP_LEFT and in_tile_dir == map.UP_RIGHT):
		return UL_UR
