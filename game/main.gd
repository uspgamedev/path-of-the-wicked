extends Node2D

onready var map = get_node('MapGenerator')

var cursor = null

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func get_hud():
	return get_node('Camera2D/HUD')

func get_panel():
	return get_node('Camera2D/HUD/Panel')

func game_over():
	print('Game Over')
