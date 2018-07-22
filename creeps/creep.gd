extends KinematicBody2D

export(int) var hp = 100
export(int) var vel = 100

onready var tween = get_node('Tween')
onready var map = get_node('../../MapGenerator')
onready var sprite = get_node('Sprite')
onready var anim = get_node('AnimationPlayer')

var projectiles = []
var towers = []
var offset

func _ready():
	if anim.has_animation('move'):
		anim.play('move')
	move()

func die():
	for proj in projectiles:
		proj.queue_free()
	for tower in towers:
		if self in tower.nearby_creeps:
			var self_idx = tower.nearby_creeps.find(self)
			tower.nearby_creeps.remove(self_idx)
	self.queue_free()

func take_damage(dmg):
	hp -= dmg
	if hp <= 0:
		die()

func move():
	randomize()
	var target = map.dict[self.position - offset]\
	             [randi() % map.dict[self.position - offset].size()] + offset
	tween.interpolate_property(self, 'position', self.position, \
	      target, float(100)/vel, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	rotate_sprite(target)

func rotate_sprite(target):
	var vector = self.position - target
	self.rotation = vector.angle() - PI/2

func _on_Tween_tween_completed(object, key):
	move()
