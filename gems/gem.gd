extends StaticBody2D

const PROJ = preload('res://projectiles/projectile.tscn')

onready var projectiles = get_node('/root/Global').get_main().get_node('Projectiles')
onready var tower = get_parent()
onready var timer = get_node('Timer')
onready var gem_colors = preload('res://gems/gem_colors.gd')

func _ready():
	timer.connect('timeout', self, '_on_Timer_timeout')

func _on_Timer_timeout():
	shoot()

func shoot():
	if tower.nearby_creeps.size() > 0:
		var proj = PROJ.instance()
		var _gem_colors = gem_colors.new()
		proj.position = tower.position
		proj.creep = tower.nearby_creeps[0]
		proj.modulate = _gem_colors.get_gem_color(self.name)
		tower.nearby_creeps[0].projectiles.append(proj)
		projectiles.add_child(proj)
		timer.start()
