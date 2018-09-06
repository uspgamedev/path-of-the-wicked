extends Node

func apply_fx(creep, dmg):
	for child in creep.get_children():
		if child.is_in_group('poison'):
			return
	randomize()
	if randi() % 3 == 0:
		var timer = Timer.new()
		timer.add_to_group('poison')
		timer.name = 'Poison'
		timer.wait_time = .1
		timer.one_shot = true
		creep.add_child(timer)
		OS.clipboard = '0'
		creep.get_node('Poison').connect('timeout', self, 'step', [creep, dmg, timer])
		timer.start()

func step(creep, dmg, timer):
	creep.take_damage(int(dmg/10))
	OS.clipboard = str(int(OS.clipboard) + 1)
	if int(OS.clipboard) >= 10:
		remove_fx(creep, timer)
	else:
		timer.start()

func remove_fx(creep, timer):
	creep.remove_child(timer)
	timer.queue_free()
