extends Node

func apply_fx(creep, dmg):
	for child in creep.get_children():
		if child.is_in_group('shock'):
			return
	randomize()
	if randi() % 3 == 0:
		var timer = Timer.new()
		timer.add_to_group('shock')
		timer.name = 'ShockTimer'
		timer.wait_time = 1
		timer.one_shot = true
		creep.add_child(timer)
		creep.get_node('ShockTimer').connect('timeout', self, 'remove_fx', [creep, timer])
		timer.start()
		if not creep.dying:
			creep.tween.playback_speed = 0
			creep.anim.playback_speed = 0

func remove_fx(creep, timer):
	creep.remove_child(timer)
	timer.queue_free()
	creep.tween.playback_speed = 1
	creep.anim.playback_speed = 1
