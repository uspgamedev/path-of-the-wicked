extends Node

onready var main = get_node('/root/Global').get_main()
onready var camera = get_parent()
onready var panel = get_node('Panel')
onready var label = get_node('Label')

var gold = 10000
var gathered = 0
var gathered_label = null
var tween_label = null

func _ready():
	label.set_text('Gold: %d' % (gold - gathered))

func _physics_process(delta):
	panel.rect_size = Vector2(panel.rect_size.x, OS.window_size.y)
	self.rect_position = camera.offset + Vector2(camera.zoom.x * OS.window_size.x - \
	                     camera.zoom.x * panel.rect_size.x, 0)

func update_gold(amount):
	gold += amount
	gathered += amount
	if gold <= 0:
		main.game_over()
	if gathered_label == null:
		gathered_label = label.duplicate(DUPLICATE_USE_INSTANCING)
		gathered_label.margin_top = 48
		self.add_child(gathered_label)
		label.get_node('Timer').start()
	gathered_label.set_text('%+d' % gathered)

func _on_Timer_timeout():
	var tween = label.get_node('Tween')
	tween_label = gathered_label.duplicate(DUPLICATE_USE_INSTANCING)
	self.add_child(tween_label)
	tween.interpolate_property(tween_label, 'margin_top', \
	            48, 16, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(tween_label, 'self_modulate', \
	            Color(1, 1, 1, 1), Color(1, 1, 1, 0), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	label.get_node('Timer').stop()
	gathered_label.queue_free()
	gathered_label = null
	gathered = 0

func _on_Tween_tween_completed(object, key):
	if key == ':margin_top':
		tween_label.queue_free()
		label.set_text('Gold: %d' % (gold - gathered))

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.gem.scale = camera.zoom

func _on_Area2D_area_exited(area):
	if main.cursor != null:
		main.cursor.gem.scale = Vector2(1, 1)
