extends Node

func apply_fx(creep, dmg):
	if creep.under_fx[1]:
		return
	randomize()
	if randi() % 3 == 0 and not creep.dying:
		creep.under_fx[1] = true
		creep.tween.playback_speed = 0
		creep.anim.playback_speed = 0
		creep.shock()
