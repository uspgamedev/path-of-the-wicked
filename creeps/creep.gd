extends Node2D

export(int) var hp = 100
export(int) var vel = 50
export(int) var reward = 100

onready var hp_bar = get_node('TextureProgress')
onready var tween = get_node('Tween')
onready var map = get_node('../../Map')
onready var sprite = get_node('Sprite')
onready var anim = get_node('AnimationPlayer')
onready var hud = get_node('/root/Main/Camera2D/HUD')

var spawner
var projectiles = []
var towers = []
var offset

func _ready():
	hp_bar.max_value = hp
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
	hud.update_gold(reward)
	self.queue_free()

func take_damage(dmg):
	hp -= dmg
	hp_bar.value += dmg
	if hp_bar.visible == false:
		hp_bar.visible = true
		if anim.has_animation('move-wounded'):
			anim.play('move-wounded')
	if hp <= 0:
		die()

func move():
	randomize()
	var target = spawner.get_next_point(self.position - offset) + offset
	tween.interpolate_property(self, 'position', self.position, \
	      target, float(100)/vel, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	rotate_sprite(target)

func rotate_sprite(target):
	var vector = self.position - target
	sprite.rotation = vector.angle() - PI/2

func _on_Tween_tween_completed(object, key):
	move()
