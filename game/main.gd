extends Node2D

var cursor = null

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func game_over():
	print('Game Over')
