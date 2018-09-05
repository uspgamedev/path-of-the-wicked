extends Node

func apply_fx(creep):
	for child in creep.get_children():
		if child.is_in_group('slow down'):
			return
	randomize()
	if randi() % 3 == 0:
		var timer = Timer.new()
		timer.add_to_group('slow down')
		timer.name = 'SlowDownTimer'
		timer.wait_time = 2
		timer.one_shot = true
		creep.add_child(timer)
		creep.get_node('SlowDownTimer').connect('timeout', self, 'remove_fx', [creep, timer])
		timer.start()
		creep.tween.playback_speed = .5
		creep.anim.playback_speed = .5

func remove_fx(creep, timer):
	creep.remove_child(timer)
	timer.queue_free()
	creep.tween.playback_speed = 1
	creep.anim.playback_speed = 1
