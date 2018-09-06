extends Node

const BLUE   = Color('00ffff')
const CLEAR  = Color('ffffff')
const GREEN  = Color('02ff1a')
const PINK   = Color('ff6cff')
const RED    = Color('c6110c')
const YELLOW = Color('ffff89')

const STRING = 0
const SCRIPT = 1

const BLUE_FX   = ['Slow down',    'res://gems/Blue/slow_down.gd']
const CLEAR_FX  = ['Shock',        'res://gems/Clear/shock.gd']
const GREEN_FX  = ['Poison',       'res://gems/Green/poison.gd']
const PINK_FX   = ['Critical Hit', 'res://gems/Pink/critical_hit.gd']
const RED_FX    = ['Splash',       'res://gems/Red/splash.gd']
const YELLOW_FX = ['Bonus Gold',   'res://gems/Yellow/bonus_gold.gd']

const TYPE1_DMG = 10
const TYPE2_DMG = 20
const TYPE3_DMG = 40
const TYPE4_DMG = 70
const TYPE5_DMG = 110
const TYPE6_DMG = 160

const COLOR = 0
const FX = 1
const REAL_NAME = 2

func get_gem_color_info(gem_name):
	if gem_name.begins_with('Blue'):
		return [BLUE, BLUE_FX, 'Blue Gem']
	if gem_name.begins_with('Clear'):
		return [CLEAR, CLEAR_FX, 'Clear Gem']
	if gem_name.begins_with('Green'):
		return [GREEN, GREEN_FX, 'Green Gem']
	if gem_name.begins_with('Pink'):
		return [PINK, PINK_FX, 'Pink Gem']
	if gem_name.begins_with('Red'):
		return [RED, RED_FX, 'Red Gem']
	if gem_name.begins_with('Yellow'):
		return [YELLOW, YELLOW_FX, 'Yellow Gem']

const TYPE = 0
const DMG = 1

func get_gem_type_info(gem_name):
	if gem_name.ends_with('1'):
		return [1, TYPE1_DMG]
	if gem_name.ends_with('2'):
		return [2, TYPE2_DMG]
	if gem_name.ends_with('3'):
		return [3, TYPE3_DMG]
	if gem_name.ends_with('4'):
		return [4, TYPE4_DMG]
	if gem_name.ends_with('5'):
		return [5, TYPE5_DMG]
	if gem_name.ends_with('6'):
		return [6, TYPE6_DMG]
