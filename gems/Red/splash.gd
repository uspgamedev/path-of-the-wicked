extends Node

const SPLASH_AREA = preload('res://gems/Red/splash_area.tscn')

func apply_fx(creep, dmg):
	randomize()
	if randi() % 3 == 0 and not creep.dying:
		var splash_area = SPLASH_AREA.instance()
		creep.get_parent().add_child(splash_area)
		splash_area.position = creep.position
		creep.splash(splash_area, dmg)
