extends Node

const HP = 0
const VEL = 1
const WEAKNESS = 2
const STRENGTH = 3

const INFO = {
	'Rat'              : [50,   50,  'Blue Gem',   'Clear Gem'],
	'Bandit'           : [100,  30,  'Clear Gem',  'Green Gem'],
	'Bee'              : [50,   60,  'Green Gem',  'Pink Gem'],
	'SkeletonMage'     : [100,  40,  'Pink Gem',   'Red Gem'],
	'Timberman'        : [200,  25,  'Red Gem',    'Yellow Gem'],
	'SkeletonKnight'   : [150,  40,  'Yellow Gem', 'Blue Gem'],
	'Hornet'           : [200,  45,  'Blue Gem',   'Green Gem'],
	'Kliver'           : [260,  45,  'Clear Gem',  'Pink Gem'],
	'Scorpion'         : [300,  50,  'Green Gem',  'Red Gem'],
	'Ogre'             : [800,  20,  'Pink Gem',   'Yellow Gem'],
	'Cockroach'        : [400,  40,  'Red Gem',    'Blue Gem'],
	'BlueMage'         : [500,  35,  'Yellow Gem', 'Clear Gem'],
	'GreenMage'        : [500,  35,  'Blue Gem',   'Pink Gem'],
	'Crawler'          : [350,  50,  'Clear Gem',  'Red Gem'],
	'Ogrillion'        : [1000, 20,  'Green Gem',  'Yellow Gem'],
	'Troll'            : [1000, 20,  'Pink Gem',   'Blue Gem'],
	'Chitiniac'        : [460,  45,  'Red Gem',    'Clear Gem'],
	'Wolfbeast'        : [600,  35,  'Yellow Gem', 'Green Gem'],
	'Ugonoth'          : [800,  35,  'Blue Gem',   'Red Gem'],
	'GargantSimple'    : [1000, 35,  'Clear Gem',  'Yellow Gem'],
	'GargantBerserker' : [1500, 30,  'Green Gem',  'Blue Gem'],
	'GargantLord'      : [1500, 30,  'Pink Gem',   'Clear Gem'],
	'GargantBoss'      : [2000, 30,  'Red Gem',    'Green Gem'],
	'Dragon'           : [1500, 50,  'Yellow Gem', 'Pink Gem'],
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
