extends Node

onready var main = get_node('/root/Global').get_main()
onready var camera = get_parent()
onready var panel = get_node('Panel')
onready var gem_db = preload('res://gems/gem_db.gd')

func _ready():
	randomize()
	for slot in panel.get_children():
		if slot.is_in_group('slot'):
			var gem = gem_db.GEMS[randi() % gem_db.GEMS.size()].instance()
			slot.gem = gem
			slot.add_child(gem)
			gem.position = slot.offset

func _physics_process(delta):
	panel.rect_size = Vector2(panel.rect_size.x, OS.window_size.y)
	self.rect_position = camera.offset + Vector2(camera.zoom.x * OS.window_size.x - \
	                     camera.zoom.x * panel.rect_size.x, 0)

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.gem.scale = camera.zoom

func _on_Area2D_area_exited(area):
	if main.cursor != null:
		main.cursor.gem.scale = Vector2(1, 1)
