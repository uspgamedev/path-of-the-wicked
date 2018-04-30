extends Node

onready var camera = get_parent()
onready var panel = get_node('Panel')

func _process(delta):
	panel.rect_size = Vector2(panel.rect_size.x, OS.window_size.y)
	self.rect_position = camera.offset + Vector2(camera.zoom.x * OS.window_size.x - \
	                     camera.zoom.x * panel.rect_size.x, 0)
