extends Node

func apply_fx(creep, dmg):
	randomize()
	if randi() % 5 == 0:
		var hud = creep.get_node('/root/Main/Camera2D/HUD')
		hud.update_gold(int(creep.reward/5))
