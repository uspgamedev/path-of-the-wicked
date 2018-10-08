extends Node2D

var tower
var vel = 25
var fx_script
var dmg
var vector
var angle
var creep
var gem_color

func _ready():
	vector = creep.position - self.position * 2
	vector = vector.normalized()

func _physics_process(delta):
	angle = vector.angle_to(creep.position - self.position * 2)
	vector = vector.rotated(angle * delta * 5)
	self.position += vector * vel/10

func _on_Area2D_area_entered(area):
	var _creep = area.get_parent()
	if _creep != null:
		if _creep.is_in_group('creep'):
			var fx = fx_script.new()
			_creep.take_damage(dmg, gem_color)
			fx.apply_fx(_creep, dmg)
			_creep.projectiles.erase(self.name)
			self.queue_free()
		elif _creep.is_in_group(str(self.name)):
			_creep.queue_free()
			self.queue_free()
