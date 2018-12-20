extends PanelContainer

const CURSOR = preload('res://game/cursor.tscn')

onready var main = get_node('/root/Main')
onready var hud = main.get_node('Camera2D/HUD')
onready var offset = self.rect_size / 2

var gem = null

func _on_Slot_mouse_entered():
	if main.cursor != null:
		main.cursor.target = self
	self.self_modulate = Color(2, 2, 2, 1)
	if gem != null:
		hud.set_popup_text(str(gem.real_name, '\n\nType: ', \
		               gem.type, '\n\nEffect:\n', gem.fx_str, '\n\nDamage: ', gem.dmg))
		hud.show_popup(self.rect_position)

func _on_Slot_mouse_exited():
	if not get_tree().paused:
		self.self_modulate = Color(.7, .7, .7, 1)
		get_viewport().warp_mouse(get_viewport().get_mouse_position())
		hud.hide_popup()

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
		hud.hide_popup()

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.target = self

func _on_Area2D_area_exited(area):
	if area.get_parent().is_in_group('cursor'):
		if main.cursor != null and main.cursor.target == self:
			main.cursor.target = null
