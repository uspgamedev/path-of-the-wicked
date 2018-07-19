extends KinematicBody2D

export(int) var vel = 40
export(int) var dmg = 10

onready var creep_wr = weakref(creep)

var vector
var creep # Assigned at gem.gd

func _physics_process(delta):
	if creep_wr.get_ref():
		vector = creep.position - self.position * 2
		vector = vector.normalized()
		self.position += vector * vel/10

func _on_Area2D_area_entered(area):
	var _creep = area.get_parent()
	if _creep != null and _creep.is_in_group('creep'):
		_creep.take_damage(dmg)
		_queue_free()

func _queue_free():
	if not self.is_queued_for_deletion():
		var self_idx = creep.projectiles.find(self)
		creep.projectiles.remove(self_idx)
		self.queue_free()
