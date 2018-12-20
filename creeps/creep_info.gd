extends Node

const HP = 0
const VEL = 1
const WEAKNESS = 2
const STRENGTH = 3

var INFO = {
	'Rat'              : [44,   50, 'Blue Gem',   'Clear Gem'],
	'Bandit'           : [97,   30, 'Clear Gem',  'Green Gem'],
	'Bee'              : [65,   60, 'Green Gem',  'Pink Gem'],
	'SkeletonMage'     : [132,  40, 'Pink Gem',   'Red Gem'],
	'Timberman'        : [293,  25, 'Red Gem',    'Yellow Gem'],
	'SkeletonKnight'   : [256,  40, 'Yellow Gem', 'Blue Gem'],
	'Hornet'           : [275,  45, 'Blue Gem',   'Green Gem'],
	'Kliver'           : [358,  45, 'Clear Gem',  'Pink Gem'],
	'Scorpion'         : [391,  50, 'Green Gem',  'Red Gem'],
	'Ogre'             : [1220, 20, 'Pink Gem',   'Yellow Gem'],
	'Cockroach'        : [738,  40, 'Red Gem',    'Blue Gem'],
	'BlueMage'         : [1031, 35, 'Yellow Gem', 'Clear Gem'],
	'GreenMage'        : [1191, 35, 'Blue Gem',   'Pink Gem'],
	'Crawler'          : [958,  50, 'Clear Gem',  'Red Gem'],
	'Ogrillion'        : [2783, 20, 'Green Gem',  'Yellow Gem'],
	'Troll'            : [3288, 20, 'Pink Gem',   'Blue Gem'],
	'Chitiniac'        : [1745, 45, 'Red Gem',    'Clear Gem'],
	'Wolfbeast'        : [2715, 35, 'Yellow Gem', 'Green Gem'],
	'Ugonoth'          : [2959, 35, 'Blue Gem',   'Red Gem'],
	'GargantSimple'    : [3511, 35, 'Clear Gem',  'Yellow Gem'],
	'GargantBerserker' : [4595, 30, 'Green Gem',  'Blue Gem'],
	'GargantLord'      : [5406, 30, 'Pink Gem',   'Clear Gem'],
	'GargantBoss'      : [5780, 30, 'Red Gem',    'Green Gem'],
	'Dragon'           : [4010, 50, 'Yellow Gem', 'Pink Gem'],
	'Demon'            : [7284, 30, '', ''],
}

func get_creep_hp(creep_name):
	return INFO[creep_name.split('-')[0]][HP]

func get_creep_vel(creep_name):
	return INFO[creep_name.split('-')[0]][VEL]

func get_creep_weakness(creep_name):
	return INFO[creep_name.split('-')[0]][WEAKNESS]

func get_creep_strength(creep_name):
	return INFO[creep_name.split('-')[0]][STRENGTH]
