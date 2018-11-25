extends Node2D

const CIRCLE = preload('res://tower/circle_drawing.gd')
const OPAQUE = '#666666'
const TRANSPARENT = '#ac666666'

onready var hud = get_node('/root/Main/Camera2D/HUD')
onready var map = get_node('/root/Main/Map')
onready var sprite = get_node('AnimatedSprite')

var draw_circle = false
var radius = 200

func _draw():
	if draw_circle:
		CIRCLE.draw_circle(self, radius)

func _on_AreaCollider_mouse_entered():
	sprite.modulate = OPAQUE
	draw_circle = true
	update()

func _on_AreaCollider_mouse_exited():
	sprite.modulate = TRANSPARENT
	draw_circle = false
	self.z_index = 0
	update()

func _on_AreaCollider_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_select') and self.visible and hud.gold >= hud.tower_price:
		map.place_tower(self.position/2)
		self.queue_free()
