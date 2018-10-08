extends Node2D

const CREEP_INFO = preload('res://creeps/creep_info.gd')

onready var hp_bar = get_node('TextureProgress')
onready var tween = get_node('Tween')
onready var map = get_node('../../Map')
onready var sprite = get_node('Sprite')
onready var anim = get_node('AnimationPlayer')
onready var hud = get_node('/root/Main/Camera2D/HUD')
onready var projectiles_node = get_node('/root/Main/Projectiles')
onready var creep_info = CREEP_INFO.new()

var max_hp
var hp
var vel
var value
var weakness
var strength
var spawner
var projectiles = {}
var towers = []
var offset
var dying = false

func _ready():
	max_hp = creep_info.get_creep_hp(self.name)
	hp = max_hp
	vel = creep_info.get_creep_vel(self.name)
	value = int(hp * vel / 100)
	weakness = creep_info.get_creep_weakness(self.name)
	strength = creep_info.get_creep_strength(self.name)
	hp_bar.max_value = hp
	if anim.has_animation('move'):
		anim.play('move')
	move()

func die():
	dying = true
	tween.stop_all()
	hud.update_gold(self.value)
	for tower in towers:
		tower.nearby_creeps.erase(self)
	for proj in projectiles_node.get_children():
		if proj in projectiles.values():
			if proj.tower.nearby_creeps.size() > 0:
				proj.creep = proj.tower.nearby_creeps[0]
				proj.creep.projectiles[proj.name] = proj
			else:
				var node = Node2D.new()
				var node_area = self.get_node('Area2D').duplicate(DUPLICATE_USE_INSTANCING)
				node.position = self.position
				node.add_child(node_area)
				node.add_to_group(str(proj.name))
				get_parent().add_child(node)
				proj.creep = node
	self.get_node('Area2D').monitoring = false
	if anim.has_animation('death') and not anim.current_animation == 'death':
		var timer = Timer.new()
		timer.wait_time = anim.current_animation_length
		timer.connect('timeout', self, '_queue_free')
		self.add_child(timer)
		timer.start()
		anim.play('death')
		self.anim.playback_speed = 1
	else:
		_queue_free()

func _queue_free():
	self.queue_free()

func take_damage(dmg, gem_color = ''):
	if gem_color == weakness:
		dmg *= 2
	elif gem_color == strength:
		dmg /= 2
	hp -= dmg
	hp_bar.value += dmg
	if not hp_bar.visible:
		hp_bar.visible = true
		if anim.has_animation('move-wounded'):
			anim.play('move-wounded')
	if hp <= 0 and not dying:
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
