extends PanelContainer

const CURSOR = preload('res://game/cursor.tscn')

onready var main = get_node('/root/Global').get_main()

var gem = null

func _on_Slot_mouse_entered():
	if main.cursor != null:
		main.cursor.slot = self
	self.self_modulate = Color(2, 2, 2, 1)
	self.mouse_default_cursor_shape = CURSOR_POINTING_HAND

func _on_Slot_mouse_exited():
	if main.cursor != null:
		main.cursor.slot = null
	self.self_modulate = Color(.7, .7, .7, 1)
	self.mouse_default_cursor_shape = CURSOR_ARROW

func _gui_input(event):
	if event.is_action_pressed('ui_select') and gem != null:
		var cursor = CURSOR.instance()
		var main = get_node('/root/Global').get_main()
		cursor.slot = self
		cursor.gem = self.gem
		cursor.source = 'slot'
		gem.position = Vector2(0, 0)
		self.remove_child(gem)
		main.add_child(cursor)
		main.cursor = cursor
		self.gem = null
