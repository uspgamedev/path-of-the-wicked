extends Node

const HP = 0
const VEL = 1
const WEAKNESS = 2
const STRENGTH = 3

const INFO = {
	'Rat'              : [50,   50, 'Blue Gem',   'Clear Gem'],
	'Bandit'           : [100,  30, 'Clear Gem',  'Green Gem'],
	'Bee'              : [65,   60, 'Green Gem',  'Pink Gem'],
	'SkeletonMage'     : [130,  40, 'Pink Gem',   'Red Gem'],
	'Timberman'        : [280,  25, 'Red Gem',    'Yellow Gem'],
	'SkeletonKnight'   : [230,  40, 'Yellow Gem', 'Blue Gem'],
	'Hornet'           : [260,  45, 'Blue Gem',   'Green Gem'],
	'Kliver'           : [320,  45, 'Clear Gem',  'Pink Gem'],
	'Scorpion'         : [350,  50, 'Green Gem',  'Red Gem'],
	'Ogre'             : [1050, 20, 'Pink Gem',   'Yellow Gem'],
	'Cockroach'        : [650,  40, 'Red Gem',    'Blue Gem'],
	'BlueMage'         : [900,  35, 'Yellow Gem', 'Clear Gem'],
	'GreenMage'        : [1100,  35, 'Blue Gem',   'Pink Gem'],
	'Crawler'          : [900,  50, 'Clear Gem',  'Red Gem'],
	'Ogrillion'        : [2600, 20, 'Green Gem',  'Yellow Gem'],
	'Troll'            : [3000, 20, 'Pink Gem',   'Blue Gem'],
	'Chitiniac'        : [1500,  45, 'Red Gem',    'Clear Gem'],
	'Wolfbeast'        : [2100, 35, 'Yellow Gem', 'Green Gem'],
	'Ugonoth'          : [2300, 35, 'Blue Gem',   'Red Gem'],
	'GargantSimple'    : [2500, 35, 'Clear Gem',  'Yellow Gem'],
	'GargantBerserker' : [3200, 30, 'Green Gem',  'Blue Gem'],
	'GargantLord'      : [3500, 30, 'Pink Gem',   'Clear Gem'],
	'GargantBoss'      : [3800, 30, 'Red Gem',    'Green Gem'],
	'Dragon'           : [2450, 50, 'Yellow Gem', 'Pink Gem'],
	'Demon'            : [4400, 30, '', ''],
}

func get_creep_hp(creep_name):
	return INFO[creep_name.split('-')[0]][HP]

func get_creep_vel(creep_name):
	return INFO[creep_name.split('-')[0]][VEL]

func get_creep_weakness(creep_name):
	return INFO[creep_name.split('-')[0]][WEAKNESS]

func get_creep_strength(creep_name):
	return INFO[creep_name.split('-')[0]][STRENGTH]
