extends Node2D

const STOP = 1

onready var hud = get_node('Camera2D/HUD')

var cursor = null
var player_won = false

func _ready():
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()
	if get_tree().paused and event.is_action_pressed('ui_accept'):
		if not player_won:
			get_tree().reload_current_scene()
		else:
			# change to credits scene
			get_tree().reload_current_scene()

func player_lost():
	game_over('You Lose!\n\nPress Space to play again')

func player_won():
	player_won = true
	game_over('You Win!\n\nPress Space')

func game_over(text):
	var notif = hud.get_node('Notifications')
	var blur_shader = hud.get_node('BlurShader')
	var panel = hud.get_node('Panel')
	for child in self.get_children():
		child.pause_mode = STOP
	notif.modulate = Color(1, 1, 1, 1)
	notif.get('custom_fonts/font').set_size(50)
	notif.text = text
	blur_shader.rect_position.x = -OS.window_size.x + panel.rect_size.x
	blur_shader.rect_size = OS.window_size
	blur_shader.visible = true
	OS.window_resizable = false
	get_tree().paused = true
