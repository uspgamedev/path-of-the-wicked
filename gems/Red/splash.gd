extends Node

func apply_fx(creep):
	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = 40
	area.add_child(collision_shape)
