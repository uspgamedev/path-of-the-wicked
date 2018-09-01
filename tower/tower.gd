extends Node2D

const CURSOR = preload('res://game/cursor.tscn')
const CIRCLE = preload('res://tower/circle_drawing.gd')

onready var cooldown = get_node('TextureProgress')
onready var area_collider = get_node('AreaCollider')
onready var nearby_area = get_node('NearbyArea')
onready var nearby_area_shape = nearby_area.get_node('CollisionShape2D')
onready var main = get_node('/root/Main')
onready var hud_area = main.get_node('Camera2D/HUD/Panel/Area2D')

var gem = null
var radius = 200
var nearby_creeps = []
var draw_circle = false
var cost = 700

func _ready():
	if self.is_in_group('shop'):
		area_collider.disconnect('area_entered', self, '_on_AreaCollider_area_entered')
		area_collider.disconnect('area_exited', self, '_on_AreaCollider_area_exited')
	set_area_radius(radius)

func _draw():
	if not self.is_in_group('shop') and draw_circle:
		CIRCLE.draw_circle(self, radius)

func set_area_radius(new_radius):
	nearby_area_shape.shape.radius = new_radius
	radius = new_radius

func _on_NearbyArea_area_entered(area):
	var creep = area.get_parent()
	if creep != null and creep.is_in_group('creep'):
		nearby_creeps.append(creep)
		creep.towers.append(self)
		if nearby_creeps.size() == 1 and cooldown.visible == false:
			if gem != null and gem.timer.time_left == 0:
				gem.shoot()

func _on_NearbyArea_area_exited(area):
	var creep = area.get_parent()
	if creep != null and creep.is_in_group('creep'):
		if creep in nearby_creeps:
			var creep_idx = nearby_creeps.find(creep)
			nearby_creeps.remove(creep_idx)

func _on_AreaCollider_input_event(viewport, event, shape_idx):
	if gem != null:
		if event.is_action_pressed('ui_select'):
			var cursor = CURSOR.instance()
			cursor.source = self
			cursor.gem = self.gem
			self.remove_child(gem)
			main.add_child(cursor)
			main.cursor = cursor
			self.gem = null
		elif event.is_action_pressed('ui_slot'):
			self.remove_child(gem)
			for slot in main.get_node('Camera2D/HUD/Panel/Inventory').get_children():
				if slot.gem == null:
					slot.gem = self.gem
					slot.add_child(gem)
					gem.position = slot.offset
					break
			self.gem = null

func start_cooldown():
	var tween = cooldown.get_node('Tween')
	cooldown.visible = true
	tween.stop_all()
	tween.interpolate_property(cooldown, 'value', 0, 100, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_completed(object, key):
	cooldown.visible = false
	if gem != null:
		gem.shoot()

func set_target(area, value):
	if main.cursor != null and self.position.x <= hud_area.global_position.x:
		main.cursor.target = value

func _on_AreaCollider_area_entered(area):
	if area.get_parent().is_in_group('cursor'):
		set_target(area, self)
		_on_AreaCollider_mouse_entered()

func _on_AreaCollider_area_exited(area):
	if area.get_parent().is_in_group('cursor'):
		set_target(area, null)
		if not cooldown.visible:
			_on_AreaCollider_mouse_exited()

func _on_AreaCollider_mouse_entered():
	draw_circle = true
	update()

func _on_AreaCollider_mouse_exited():
	draw_circle = false
	self.z_index = 0
	update()

func _on_TextureProgress_mouse_exited():
	_on_AreaCollider_mouse_exited()

func _on_TextureProgress_mouse_entered():
	_on_AreaCollider_mouse_entered()
