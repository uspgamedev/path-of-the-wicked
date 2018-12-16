extends Node

func apply_fx(creep, dmg):
	randomize()
	if randi() % 5 == 0:
		creep.take_damage(dmg, 'Pink Gem')
