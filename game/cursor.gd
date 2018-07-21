extends Node2D

var gem
var source
var target

func _ready():
	self.add_child(gem)
	self.position = get_global_mouse_position()

func move_gem(node):
	node.add_child(gem)
	node.gem = gem
	if node.is_in_group('slot'):
		gem.position += node.offset
	elif node.is_in_group('tower'):
		gem.timer.start()

func _input(event):
	if event.is_class('InputEventMouseMotion'):
		self.position = get_global_mouse_position()
	elif event.is_action_released('ui_select'):
		self.remove_child(gem)
		if target == null:
			move_gem(source)
		else:
			move_gem(target)
		if source.is_in_group('slot') and source != target:
			source._on_Slot_mouse_exited()
		get_parent().cursor = null
		self.queue_free()
