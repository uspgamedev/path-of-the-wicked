extends Node

const REAL_NAME = 0
const FX_STR = 1
const FX_SCRIPT = 2
const COLOR = 3

const COLOR_INFO = {
	'BlueGem'   : ['Blue Gem',   'Slow down',    preload('res://gems/Blue/slow_down.gd'),    Color('00ffff')],
	'ClearGem'  : ['Clear Gem',  'Shock',        preload('res://gems/Clear/shock.gd'),       Color('ffffff')],
	'GreenGem'  : ['Green Gem',  'Poison',       preload('res://gems/Green/poison.gd'),      Color('02ff1a')],
	'PinkGem'   : ['Pink Gem',   'Critical Hit', preload('res://gems/Pink/critical_hit.gd'), Color('ff6cff')],
	'RedGem'    : ['Red Gem',    'Splash',       preload('res://gems/Red/splash.gd'),        Color('c6110c')],
	'YellowGem' : ['Yellow Gem', 'Bonus Gold',   preload('res://gems/Yellow/bonus_gold.gd'), Color('ffff89')]
}

const DMG = 0
const PRICE = 1

const TYPE_INFO = {
	'1' : [10, 1000],
	'2' : [20, 4000],
	'3' : [30, 12000],
	'4' : [40, 24000],
	'5' : [50, 36000],
	'6' : [60, 45000]
}

const SHOT_COOLDOWN = .4

func get_gem_real_name(gem_name):
	return COLOR_INFO[gem_name.substr(0, gem_name.length() -1)][REAL_NAME]

func get_gem_fx_str(gem_name):
	return COLOR_INFO[gem_name.substr(0, gem_name.length() -1)][FX_STR]

func get_gem_fx_script(gem_name):
	return COLOR_INFO[gem_name.substr(0, gem_name.length() -1)][FX_SCRIPT]

func get_gem_color(gem_name):
	return COLOR_INFO[gem_name.substr(0, gem_name.length() -1)][COLOR]

func get_gem_dmg(gem_type):
	return TYPE_INFO[gem_type][DMG]

func get_gem_price(gem_type):
	return TYPE_INFO[gem_type][PRICE]

func get_gem_shot_cooldown():
	return SHOT_COOLDOWN
