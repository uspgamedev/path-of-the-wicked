extends Node2D

const CURSOR = preload('res://game/cursor.tscn')
const BIG_CIRCLE = preload('res://tower/circle/big_circle.png')
const SMALL_CIRCLE = preload('res://tower/circle/small_circle.png')

onready var circle = get_node('Circle')
onready var cooldown = get_node('TextureProgress')
onready var area_collider = get_node('AreaCollider')
onready var nearby_area = get_node('NearbyArea')
onready var nearby_area_shape = nearby_area.get_node('CollisionShape2D')
onready var main = get_node('/root/Main')
onready var hud = main.get_node('Camera2D/HUD')
onready var hud_area = hud.get_node('Panel/PanelArea')
onready var inventory = main.get_node('Camera2D/HUD/Panel/Inventory')
onready var map = main.get_node('Map')

var gem = null
var radius = 200
var nearby_creeps = []

func _ready():
	if self.is_in_group('shop'):
		area_collider.disconnect('area_entered', self, '_on_AreaCollider_area_entered')
		area_collider.disconnect('area_exited', self, '_on_AreaCollider_area_exited')
	set_area_radius(radius)
	circle.z_index = 1

func set_area_radius(new_radius):
	nearby_area_shape.shape.radius = new_radius
	radius = new_radius

func _on_NearbyArea_area_entered(area):
	var creep = area.get_parent()
	if creep != null and creep.is_in_group('creep') and not creep.dying:
		nearby_creeps.append(creep)
		creep.towers.append(self)
		if nearby_creeps.size() == 1 and not cooldown.visible:
			if gem != null and gem.timer.time_left == 0:
				gem.shoot()

func _on_NearbyArea_area_exited(area):
	var creep = area.get_parent()
	if creep != null and creep.is_in_group('creep'):
		nearby_creeps.erase(creep)

func _on_AreaCollider_input_event(viewport, event, shape_idx):
	if gem != null:
		if event.is_action_pressed('ui_select'):
			var cursor = CURSOR.instance()
			cursor.source = self
			cursor.gem = self.gem
			self.remove_child(gem)
			main.add_child(cursor)
			main.cursor = cursor
			map.update_AStar_weights(self, -gem.dmg, gem.real_name)
			self.gem = null
		elif event.is_action_pressed('ui_slot'):
			var slot = inventory.get_empty_slot()
			if slot != null:
				self.remove_child(gem)
				slot.gem = self.gem
				slot.add_child(gem)
				gem.position = slot.offset
				map.update_AStar_weights(self, -gem.dmg, gem.real_name)
				self.gem = null
			_on_AreaCollider_mouse_entered()

func start_cooldown():
	var tween = cooldown.get_node('Tween')
	cooldown.visible = true
	tween.stop_all()
	tween.interpolate_property(cooldown, 'value', 0, 100, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	if (self.position / hud.camera.zoom.x - hud.camera.offset - \
	                    get_viewport().get_mouse_position()).length() > 32:
		_on_AreaCollider_mouse_exited()
	map.update_AStar_weights(self, gem.dmg, gem.real_name)

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
	var camera = hud.camera
	var offset = Vector2(-34, 34) / camera.zoom.x
	var pos =  self.position / camera.zoom.x - camera.offset - Vector2(OS.window_size.x - \
	           hud.panel.rect_size.x, 0) + offset
	update_circle_texture()
	circle.visible = true
	if gem == null:
		hud.set_popup_text(str('Tower\n\nRange: ', radius))
	else:
		hud.set_popup_text(str('Tower with \n', gem.real_name, '\n\nType: ', gem.type, \
		             '\n\nEffect:\n', gem.fx_str, '\n\nDamage: ', gem.dmg, '\n\nRange: ', radius))
	hud.show_popup(pos)

func update_circle_texture():
	if main.get_node('Camera2D').zoom == Vector2(1, 1):
		circle.scale = Vector2(1, 1)
		circle.texture = BIG_CIRCLE
	else:
		circle.scale = Vector2(2, 2)
		circle.texture = SMALL_CIRCLE

func _on_AreaCollider_mouse_exited():
	circle.visible = false
	self.z_index = 0
	hud.hide_popup()

func _on_TextureProgress_mouse_exited():
	_on_AreaCollider_mouse_exited()

func _on_TextureProgress_mouse_entered():
	_on_AreaCollider_mouse_entered()
