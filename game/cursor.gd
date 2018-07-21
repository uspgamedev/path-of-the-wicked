extends Node2D

var gem
var slot
var tower
var offset
var source

func _ready():
	self.add_child(gem)
	offset = Vector2(20, 20)
	self.position = get_global_mouse_position()

func _input(event):
	if event.is_class('InputEventMouseMotion'):
		self.position = get_global_mouse_position()
	elif event.is_action_released('ui_select'):
		self.remove_child(gem)
		if (source == 'slot' and tower != null) or (source == 'tower' and slot == null):
			tower.add_child(gem)
			tower.gem = gem
			gem.timer.start()
		elif (source == 'tower' and slot != null) or (source == 'slot' and tower == null):
			slot.add_child(gem)
			slot.gem = gem
			gem.position += offset
		get_parent().cursor = null
		self.queue_free()
