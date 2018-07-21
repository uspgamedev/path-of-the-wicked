extends StaticBody2D


const CURSOR = preload('res://game/cursor.tscn')

onready var nearby_area = get_node('NearbyArea')
onready var nearby_area_shape = nearby_area.get_node('CollisionShape2D')
onready var main = get_node('/root/Global').get_main()

var gem = null
var radius = 200
var nearby_creeps = []

func _ready():
	set_area_radius(radius)
	self.input_pickable = true

func set_area_radius(new_radius):
	nearby_area_shape.shape.radius = new_radius
	radius = new_radius

func _on_NearbyArea_area_entered(area):
	var creep = area.get_parent()
	if gem != null and creep != null and creep.is_in_group('creep'):
		nearby_creeps.append(creep)
		creep.towers.append(self)
		if nearby_creeps.size() == 1:
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
			for slot in main.get_panel().get_children():
				if slot.gem == null:
					slot.gem = self.gem
					slot.add_child(gem)
					gem.position = slot.offset
					break
			self.gem = null

func _on_AreaCollider_area_entered(area):
	if area.get_parent().is_in_group('cursor'):
		main.cursor.target = self

func _on_AreaCollider_area_exited(area):
	if area.get_parent().is_in_group('cursor'):
		if main.cursor != null:
			main.cursor.target = null
