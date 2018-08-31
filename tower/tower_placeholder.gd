extends Node2D

const OPAQUE = '#666666'
const TRANSPARENT = '#ac666666'

onready var map = get_node('/root/Main/Map')
onready var sprite = get_node('AnimatedSprite')

func _on_AreaCollider_mouse_entered():
	sprite.modulate = OPAQUE

func _on_AreaCollider_mouse_exited():
	sprite.modulate = TRANSPARENT

func _on_AreaCollider_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_select') and self.visible:
		map.place_tower(self.position/2)
		self.queue_free()
