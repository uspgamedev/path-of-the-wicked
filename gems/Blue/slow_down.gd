extends Node

func apply_fx(creep, dmg):
	if creep.under_fx[2]:
		return
	randomize()
	if randi() % 3 == 0 and not creep.dying:
		creep.under_fx[2] = true
		creep.tween.playback_speed = .5
		creep.anim.playback_speed = .5
		creep.slow_down()
