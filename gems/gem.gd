extends Node2D

const PROJ = preload('res://projectiles/projectile.tscn')
const GEM_INFO = preload('res://gems/gem_info.gd')

onready var projectiles = get_node('/root/Main/Projectiles')
onready var timer = get_node('Timer')
onready var gem_info = GEM_INFO.new()

var tower
var real_name
var color
var fx
var dmg
var type
var price

func _ready():
	timer.connect('timeout', self, '_on_Timer_timeout')
	var color_info = gem_info.get_gem_color_info(self.name)
	var type_info = gem_info.get_gem_type_info(self.name)
	color = color_info[0]
	fx = color_info[1]
	real_name = color_info[2]
	type = type_info[0]
	dmg = type_info[1]
	price = type * 100

func _on_Timer_timeout():
	shoot()

func shoot():
	tower = get_parent()
	if tower.is_in_group('tower') and tower.nearby_creeps.size() > 0:
		var proj = PROJ.instance()
		proj.position = tower.position
		proj.creep = tower.nearby_creeps[0]
		proj.modulate = color
		proj.dmg = self.dmg
		proj.fx = self.fx
		tower.nearby_creeps[0].projectiles.append(proj)
		projectiles.add_child(proj)
		timer.start()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_select'):
		timer.stop()
