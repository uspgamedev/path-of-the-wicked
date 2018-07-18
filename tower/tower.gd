extends StaticBody2D

export(NodePath) var gem = null
export(int) var radius = 200

onready var nearby_area = get_node('NearbyArea')
onready var nearby_area_shape = nearby_area.get_node('CollisionShape2D')

var nearby_creeps = []

func _ready():
	set_area_radius(radius)

func set_area_radius(new_radius):
	nearby_area_shape.shape.radius = new_radius
	radius = new_radius

func _on_NearbyArea_area_entered(area):
	var creep = area.get_parent()
	if gem != null and creep != null and creep.is_in_group('creep'):
		nearby_creeps.append(creep)
		creep.towers.append(self)
		if nearby_creeps.size() == 1:
			get_node(gem).shoot()

func _on_NearbyArea_area_exited(area):
	var creep = area.get_parent()
	if creep != null and creep.is_in_group('creep'):
		if creep in nearby_creeps:
			var creep_idx = nearby_creeps.find(creep)
			nearby_creeps.remove(creep_idx)
