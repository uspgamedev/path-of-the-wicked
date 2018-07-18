extends Node

func _ready():
	OS.center_window()

func get_main():
	return get_node('/root/Main')
