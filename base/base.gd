extends Node2D

func _ready():
	self.z_index = 1

func _on_Area2D_area_entered(area):
	var creep = area.get_parent()
	if creep.is_in_group('creep'):
		creep.value = int(creep.value * -3 * float(creep.hp) / creep.max_hp)
		creep.die()
