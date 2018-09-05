extends Control

onready var main = get_node('/root/Main')
onready var camera = get_parent()
onready var panel = get_node('Panel')
onready var gold_label = get_node('Gold')
onready var next_wave = get_node('NextWave')
onready var gold_timer = get_node('Gold/GoldTimer')
onready var notif = get_node('Notifications')
onready var popup = get_node('Popup')
onready var info = popup.get_node('Info')

var gold = 1000000
var gathered = 0
var gathered_label = null
var tween_label = null
var wave_delay = 3

func _ready():
	gold_label.set_text('Gold: %d' % (gold - gathered))

func _physics_process(delta):
	panel.rect_size = Vector2(panel.rect_size.x, OS.window_size.y)
	self.rect_position = camera.offset + Vector2(camera.zoom.x * OS.window_size.x - \
                         camera.zoom.x * panel.rect_size.x, 0)
	notif.rect_size = OS.window_size - Vector2(panel.rect_size.x, 0)
	notif.rect_position.x = -notif.rect_size.x
	next_wave.rect_position.x = panel.rect_size.x + 20 - OS.window_size.x

func update_gold(amount):
	gold += amount
	gathered += amount
	if gold <= 0:
		main.game_over()
	if gathered_label == null:
		gathered_label = gold_label.duplicate(DUPLICATE_USE_INSTANCING)
		gathered_label.margin_top = 48
		self.add_child(gathered_label)
		gold_timer.start()
	gathered_label.set_text('%+d' % gathered)

func _on_GoldTimer_timeout():
	var gold_tween = gold_label.get_node('GoldTween')
	tween_label = gathered_label.duplicate(DUPLICATE_USE_INSTANCING)
	self.add_child(tween_label)
	gold_tween.interpolate_property(tween_label, 'margin_top', \
	            48, 16, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	gold_tween.interpolate_property(tween_label, 'self_modulate', \
	            Color(1, 1, 1, 1), Color(1, 1, 1, 0), .5, \
	                  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	gold_tween.start()
	gold_timer.stop()
	gathered_label.queue_free()
	gathered_label = null
	gathered = 0

func _on_GoldTween_tween_completed(object, key):
	if key == ':margin_top':
		tween_label.queue_free()
		gold_label.set_text('Gold: %d' % (gold - gathered))

func _on_PanelArea_area_entered(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.gem.scale = camera.zoom

func _on_PanelArea_area_exited(area):
	if main.cursor != null:
		main.cursor.gem.scale = Vector2(1, 1)

func start_countdown():
	var nw_tween = get_node('NextWave/NextWaveTween')
	var bar = get_node('NextWave/TextureProgress')
	next_wave.visible = true
	nw_tween.interpolate_property(bar, 'value', 0, 100, wave_delay, \
	                              Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	nw_tween.start()

func _on_NotificationsTimer_timeout():
	var notif_tween = get_node('Notifications/Tween')
	notif_tween.interpolate_property(notif, 'modulate', \
	            Color(1, 1, 1, 1), Color(1, 1, 1, 0), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	notif_tween.start()
	start_countdown()

func _on_NextWaveTween_tween_completed(object, key):
	var wave_manager = get_node('/root/Main/WaveManager')
	next_wave.visible = false
	wave_manager.start_wave()

func set_popup_text(_text):
	info.text = _text
	info.rect_size = Vector2(info.rect_size.x, info.get_line_height() * info.get_line_count())
	popup.rect_size = info.rect_size + Vector2(info.margin_left * 2, info.margin_top * 2)

func is_mouse_inside_rect():
	var mouse_pos = get_viewport().get_mouse_position()
	var rect_pos = popup.rect_position + Vector2(OS.window_size.x - panel.rect_size.x, 0)
	if mouse_pos.x >= rect_pos.x and mouse_pos.x <= (rect_pos + popup.rect_size).x:
		if mouse_pos.y >= rect_pos.y and mouse_pos.y <= (rect_pos + popup.rect_size).y:
			return true
	return false

func show_popup(pos):
	if camera.holding_cam: return
	popup.rect_position.x = max(pos.x - popup.rect_size.x, panel.rect_size.x - OS.window_size.x)
	popup.rect_position.y = max(0, min(pos.y, OS.window_size.y - popup.rect_size.y))
	if is_mouse_inside_rect(): return
	popup.visible = true

func hide_popup():
	popup.visible = false

func _on_Popup_mouse_entered():
	hide_popup()
