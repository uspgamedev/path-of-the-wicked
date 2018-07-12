extends Node2D

func _on_Timer_timeout():
	get_node('../../').spawn_enemy(self)
