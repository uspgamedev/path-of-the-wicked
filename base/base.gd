extends Node2D

func _on_Area2D_area_entered(area):
	var creep = area.get_parent()
	if creep.is_in_group('creep'):
		creep.reward *= -5
		creep.die()
