extends Node

func apply_fx(creep, dmg):
	randomize()
	if randi() % 5 == 0 and not creep.dying:
		var hud = creep.get_node('/root/Main/Camera2D/HUD')
		hud.update_gold(int(creep.value / 5))
