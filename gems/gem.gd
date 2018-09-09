extends Node2D

const PROJ = preload('res://projectiles/projectile.tscn')
const GEM_INFO = preload('res://gems/gem_info.gd')

onready var projectiles = get_node('/root/Main/Projectiles')
onready var timer = get_node('Timer')
onready var gem_info = GEM_INFO.new()

var tower
var real_name
var fx_str
var fx_script
var color
var type
var dmg
var price

func _ready():
	real_name = gem_info.get_gem_real_name(self.name)
	fx_str = gem_info.get_gem_fx_str(self.name)
	fx_script = gem_info.get_gem_fx_script(self.name)
	color = gem_info.get_gem_color(self.name)
	type = self.name[-1]
	dmg = gem_info.get_gem_dmg(type)
	price = gem_info.get_gem_price(type)
	timer.wait_time = gem_info.get_gem_shot_cooldown()

func _on_Timer_timeout():
	shoot()

func shoot():
	tower = get_parent()
	if tower.is_in_group('tower') and tower.nearby_creeps.size() > 0:
		var proj = PROJ.instance()
		proj.position = tower.position
		proj.creep = tower.nearby_creeps[0]
		proj.modulate = self.color
		proj.gem_color = self.real_name
		proj.dmg = self.dmg
		proj.fx_script = self.fx_script
		tower.nearby_creeps[0].projectiles.append(proj)
		projectiles.add_child(proj)
		timer.start()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_select'):
		timer.stop()
