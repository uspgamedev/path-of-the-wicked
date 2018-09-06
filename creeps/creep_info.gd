extends Node

const WEAKNESS = 0
const STRENGTH = 1

var dict = {
	'BANDIT'           : ['Blue Gem',   'Clear Gem'],
	'BEE'              : ['Blue Gem',   'Green Gem'],
	'CHITINIAC'        : ['Blue Gem',   'Pink Gem'],
	'COCKROACH'        : ['Blue Gem',   'Red Gem'],
	'CRAWLER'          : ['Clear Gem',  'Yellow Gem'],
	'DEMON'            : ['', ''],
	'DRAGON'           : ['Clear Gem',  'Blue Gem'],
	'GARGANTBERSERKER' : ['Clear Gem',  'Green Gem'],
	'GARGANTBOSS'      : ['Clear Gem',  'Pink Gem'],
	'GARGANTLORD'      : ['Green Gem',  'Red Gem'],
	'GARGANTSIMPLE'    : ['Green Gem',  'Yellow Gem'],
	'HORNET'           : ['Green Gem',  'Blue Gem'],
	'KLIVER'           : ['Green Gem',  'Clear Gem'],
	'BLUEMAGE'         : ['Pink Gem',   'Green Gem'],
	'GREENMAGE'        : ['Pink Gem',   'Red Gem'],
	'OGRE'             : ['Pink Gem',   'Yellow Gem'],
	'OGRILLION'        : ['Pink Gem',   'Blue Gem'],
	'RAT'              : ['Red Gem',    'Clear Gem'],
	'SCORPION'         : ['Red Gem',    'Green Gem'],
	'SKELETONKNIGHT'   : ['Red Gem',    'Pink Gem'],
	'SKELETONMAGE'     : ['Red Gem',    'Yellow Gem'],
	'TIMBERMAN'        : ['Yellow Gem', 'Blue Gem'],
	'TROLL'            : ['Yellow Gem', 'Clear Gem'],
	'UGONOTH'          : ['Yellow Gem', 'Red Gem'],
	'WOLFBEAST'        : ['Yellow Gem', 'Pink Gem'],
}

func parse_creep_name(creep_name):
	if creep_name.begins_with('@'):
		return creep_name.to_upper().split('@')[1]
	else:
		return creep_name.to_upper()

func get_creep_weakness(creep_name):
	creep_name = parse_creep_name(creep_name)
	return dict[creep_name][WEAKNESS]

func get_creep_strength(creep_name):
	creep_name = parse_creep_name(creep_name)
	return dict[creep_name][STRENGTH]
