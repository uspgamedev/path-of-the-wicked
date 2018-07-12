extends KinematicBody2D

onready var tween = get_node('Tween')
onready var map = get_node('../../MapGenerator')
onready var sprite = get_node('Sprite')
onready var anim = get_node('AnimationPlayer')

func _ready():
	if anim.has_animation('move'):
		anim.play('move')
	move()

func move():
	var target = map.dict[self.position][randi() % map.dict[self.position].size()]
	tween.interpolate_property(self, 'position', self.position, \
	      target, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	rotate_sprite(target)

func rotate_sprite(target):
	var vector = self.position - target
	self.rotation = vector.angle() - PI/2

func _on_Tween_tween_completed(object, key):
	move()
