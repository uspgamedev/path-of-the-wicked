extends PanelContainer

const CURSOR = preload('res://game/cursor.tscn')

onready var main = get_node('/root/Main')
onready var offset = self.rect_size / 2

var gem = null

func _on_Slot_mouse_entered():
	if main.cursor != null:
		main.cursor.target = self
	self.self_modulate = Color(2, 2, 2, 1)
#	self.mouse_default_cursor_shape = CURSOR_POINTING_HAND

func _on_Slot_mouse_exited():
	self.self_modulate = Color(.7, .7, .7, 1)
#	self.mouse_default_cursor_shape = CURSOR_ARROW
	get_viewport().warp_mouse(get_viewport().get_mouse_position())

func _gui_input(event):
	if event.is_action_pressed('ui_select') and gem != null:
		var cursor = CURSOR.instance()
		cursor.source = self
		cursor.gem = self.gem
		gem.position = Vector2(0, 0)
		self.remove_child(gem)
		main.add_child(cursor)
		main.cursor = cursor
		self.gem = null

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.target = self

func _on_Area2D_area_exited(area):
	if area.get_parent().is_in_group('cursor'):
		if main.cursor != null and main.cursor.target == self:
			main.cursor.target = null
