extends Node2D

onready var hud = get_node('Camera2D/HUD')
const STOP = 1

var cursor = null

func _ready():
	OS.window_resizable = true

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()
	if get_tree().paused and event.is_action_pressed('ui_accept'):
		get_tree().reload_current_scene()

func game_over():
	var notif = hud.get_node('Notifications')
	var blur_shader = hud.get_node('BlurShader')
	var panel = hud.get_node('Panel')
	for child in self.get_children():
		child.pause_mode = STOP
	notif.modulate = Color(1, 1, 1, 1)
	notif.get('custom_fonts/font').set_size(50)
	notif.text = 'Game Over\n\nPress Space to play again'
	blur_shader.rect_position.x = -OS.window_size.x + panel.rect_size.x
	blur_shader.rect_size = OS.window_size
	blur_shader.visible = true
	OS.window_resizable = false
	get_tree().paused = true
