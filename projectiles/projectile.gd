extends KinematicBody2D

export(int) var vel = 30
export(int) var dmg = 10

var vector
var creep # Assigned at gem.gd

func _physics_process(delta):
	vector = creep.position - self.position * 2
	vector = vector.normalized()
	self.position += vector * vel/10

func _on_Area2D_area_entered(area):
	var creep = area.get_parent()
	if creep != null and creep.is_in_group('creep'):
		creep.take_damage(dmg)
		_queue_free()

func _queue_free():
	if not self.is_queued_for_deletion():
		var self_idx = creep.projectiles.find(self)
		creep.projectiles.remove(self_idx)
		self.queue_free()

func _on_Timer_timeout():
	_queue_free()
