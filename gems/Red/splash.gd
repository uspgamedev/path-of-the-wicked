extends Node

const SPLASH_AREA = preload('res://gems/Red/splash_area.tscn')

func apply_fx(creep, dmg):
	randomize()
	if randi() % 3 == 0:
		var splash_area = SPLASH_AREA.instance()
		var creep_wr = weakref(creep)
		creep.get_parent().add_child(splash_area)
		splash_area.position = creep.position
		yield(creep.get_tree(), 'physics_frame')
		if creep_wr.get_ref():
			yield(creep.get_tree(), 'physics_frame')
			if creep_wr.get_ref():
				for creep_area in splash_area.get_overlapping_areas():
					var _creep = creep_area.get_parent()
					if _creep != creep and _creep.is_in_group('creep'):
						_creep.take_damage(int(dmg/2))
		splash_area.queue_free()
