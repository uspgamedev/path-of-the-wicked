extends Node2D

const BIG_CIRCLE = preload('res://tower/circle/big_circle.png')
const SMALL_CIRCLE = preload('res://tower/circle/small_circle.png')
const OPAQUE = '#666666'
const TRANSPARENT = '#ac666666'

onready var circle = get_node('Circle')
onready var hud = get_node('/root/Main/Camera2D/HUD')
onready var map = get_node('/root/Main/Map')
onready var sprite = get_node('AnimatedSprite')

var radius = 200

func _ready():
	circle.z_index = 1

func update_circle_texture():
	if map.get_node('../Camera2D').zoom == Vector2(1, 1):
		circle.scale = Vector2(1, 1)
		circle.texture = BIG_CIRCLE
	else:
		circle.scale = Vector2(2, 2)
		circle.texture = SMALL_CIRCLE

func _on_AreaCollider_mouse_entered():
	sprite.modulate = OPAQUE
	update_circle_texture()
	circle.visible = true

func _on_AreaCollider_mouse_exited():
	sprite.modulate = TRANSPARENT
	circle.visible = false
	self.z_index = 0

func _on_AreaCollider_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_select') and self.visible and hud.gold >= hud.tower_price:
		map.place_tower(self.position/2)
		self.queue_free()
