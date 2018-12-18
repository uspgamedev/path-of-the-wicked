extends Node

const HP = 0
const VEL = 1
const WEAKNESS = 2
const STRENGTH = 3

var INFO = {
	'Rat'              : [50, 'Blue Gem',   'Clear Gem'],
	'Bandit'           : [30, 'Clear Gem',  'Green Gem'],
	'Bee'              : [60, 'Green Gem',  'Pink Gem'],
	'SkeletonMage'     : [40, 'Pink Gem',   'Red Gem'],
	'Timberman'        : [25, 'Red Gem',    'Yellow Gem'],
	'SkeletonKnight'   : [40, 'Yellow Gem', 'Blue Gem'],
	'Hornet'           : [45, 'Blue Gem',   'Green Gem'],
	'Kliver'           : [45, 'Clear Gem',  'Pink Gem'],
	'Scorpion'         : [50, 'Green Gem',  'Red Gem'],
	'Ogre'             : [20, 'Pink Gem',   'Yellow Gem'],
	'Cockroach'        : [40, 'Red Gem',    'Blue Gem'],
	'BlueMage'         : [35, 'Yellow Gem', 'Clear Gem'],
	'GreenMage'        : [35, 'Blue Gem',   'Pink Gem'],
	'Crawler'          : [50, 'Clear Gem',  'Red Gem'],
	'Ogrillion'        : [20, 'Green Gem',  'Yellow Gem'],
	'Troll'            : [20, 'Pink Gem',   'Blue Gem'],
	'Chitiniac'        : [45, 'Red Gem',    'Clear Gem'],
	'Wolfbeast'        : [35, 'Yellow Gem', 'Green Gem'],
	'Ugonoth'          : [35, 'Blue Gem',   'Red Gem'],
	'GargantSimple'    : [35, 'Clear Gem',  'Yellow Gem'],
	'GargantBerserker' : [30, 'Green Gem',  'Blue Gem'],
	'GargantLord'      : [30, 'Pink Gem',   'Clear Gem'],
	'GargantBoss'      : [30, 'Red Gem',    'Green Gem'],
	'Dragon'           : [50, 'Yellow Gem', 'Pink Gem'],
	'Demon'            : [30, '', ''],
}

func init():
	var file = File.new()
	file.open('sheet.csv', file.READ)
	file.seek(0)
	var dict_headers = []
	var is_header = true
	var attributes_list = []
	var keys = INFO.keys()
	var j = 0
	while !file.eof_reached():
		var line = file.get_csv_line()
		if is_header:
			attributes_list = line
			for item in attributes_list:
				dict_headers.append(item)
			is_header = false
		else:
			for i in range(0, attributes_list.size()):
				if attributes_list[i] == 'HP':
					var value = INFO[keys[j]]
					value.push_front(int(line[i]))
					INFO[keys[j]] = value
					j += 1
	file.close()

func get_creep_hp(creep_name):
	return INFO[creep_name.split('-')[0]][HP]

func get_creep_vel(creep_name):
	return INFO[creep_name.split('-')[0]][VEL]

func get_creep_weakness(creep_name):
	return INFO[creep_name.split('-')[0]][WEAKNESS]

func get_creep_strength(creep_name):
	return INFO[creep_name.split('-')[0]][STRENGTH]
