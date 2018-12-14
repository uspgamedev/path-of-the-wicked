extends Node

const HP = 0
const VEL = 1
const WEAKNESS = 2
const STRENGTH = 3

const INFO = {
	'Rat'              : [50,   50,  'Red Gem',    'Clear Gem'],
	'Bandit'           : [100,  30,  'Blue Gem',   'Clear Gem'],
	'Bee'              : [50,   60,  'Blue Gem',   'Green Gem'],
	'SkeletonMage'     : [100,  40,  'Red Gem',    'Yellow Gem'],
	'Timberman'        : [200,  25,  'Yellow Gem', 'Blue Gem'],
	'SkeletonKnight'   : [150,  40,  'Red Gem',    'Pink Gem'],
	'Hornet'           : [200,  45,  'Green Gem',  'Blue Gem'],
	'Kliver'           : [260,  45,  'Green Gem',  'Clear Gem'],
	'Scorpion'         : [300,  50,  'Red Gem',    'Green Gem'],
	'Ogre'             : [800,  20,  'Pink Gem',   'Yellow Gem'],
	'Cockroach'        : [400,  40,  'Blue Gem',   'Red Gem'],
	'BlueMage'         : [500,  35,  'Pink Gem',   'Green Gem'],
	'GreenMage'        : [500,  35,  'Pink Gem',   'Red Gem'],
	'Crawler'          : [350,  50,  'Clear Gem',  'Yellow Gem'],
	'Ogrillion'        : [1000, 20,  'Pink Gem',   'Blue Gem'],
	'Troll'            : [1000, 20,  'Yellow Gem', 'Clear Gem'],
	'Chitiniac'        : [460,  45,  'Blue Gem',   'Pink Gem'],
	'Wolfbeast'        : [600,  35,  'Yellow Gem', 'Pink Gem'],
	'Ugonoth'          : [800,  35,  'Yellow Gem', 'Red Gem'],
	'GargantSimple'    : [1000, 35,  'Green Gem',  'Yellow Gem'],
	'GargantBerserker' : [1500, 30,  'Clear Gem',  'Green Gem'],
	'GargantLord'      : [1500, 30,  'Green Gem',  'Red Gem'],
	'GargantBoss'      : [2000, 30,  'Clear Gem',  'Pink Gem'],
	'Dragon'           : [1500, 50,  'Clear Gem',  'Blue Gem'],
	'Demon'            : [3000, 30,  '', ''],
}

func get_creep_hp(creep_name):
	return INFO[creep_name.split('-')[0]][HP]

func get_creep_vel(creep_name):
	return 10 * INFO[creep_name.split('-')[0]][VEL]

func get_creep_weakness(creep_name):
	return INFO[creep_name.split('-')[0]][WEAKNESS]

func get_creep_strength(creep_name):
	return INFO[creep_name.split('-')[0]][STRENGTH]
