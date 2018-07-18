extends Node

const BLUE   = Color('00ffff')
const CLEAR  = Color('ffffff')
const GREEN  = Color('02ff1a')
const PINK   = Color('ff6cff')
const RED    = Color('c6110c')
const YELLOW = Color('ffff89')

func get_gem_color(gem_name):
	if gem_name.begins_with('Blue'):
		return BLUE
	elif gem_name.begins_with('Clear'):
		return CLEAR
	elif gem_name.begins_with('Green'):
		return GREEN
	elif gem_name.begins_with('Pink'):
		return PINK
	elif gem_name.begins_with('Red'):
		return RED
	elif gem_name.begins_with('Yellow'):
		return YELLOW
