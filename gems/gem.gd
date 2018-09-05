extends Node2D

const PROJ = preload('res://projectiles/projectile.tscn')
const GEM_INFO = preload('res://gems/gem_info.gd')

onready var projectiles = get_node('/root/Main/Projectiles')
onready var timer = get_node('Timer')
onready var gem_info = GEM_INFO.new()

var tower
var real_name
var color
var fx_str
var fx_script
var dmg
var type
var price
var wait_time = 0.2

func _ready():
	var color_info = gem_info.get_gem_color_info(self.name)
	var type_info = gem_info.get_gem_type_info(self.name)
	color = color_info[gem_info.COLOR]
	fx_str = color_info[gem_info.FX][gem_info.STRING]
	fx_script = load(color_info[gem_info.FX][gem_info.SCRIPT])
	real_name = color_info[gem_info.REAL_NAME]
	type = type_info[gem_info.TYPE]
	dmg = type_info[gem_info.DMG]
	price = type * 100
	timer.wait_time = wait_time

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
		proj.fx_script = self.fx_script
		tower.nearby_creeps[0].projectiles.append(proj)
		projectiles.add_child(proj)
		timer.start()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('ui_select'):
		timer.stop()
