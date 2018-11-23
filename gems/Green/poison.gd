extends Node

func apply_fx(creep, dmg):
	if creep.under_fx[0]:
		return
	randomize()
	if randi() % 3 == 0 and not creep.dying:
		creep.under_fx[0] = true
		creep.poison(dmg)
