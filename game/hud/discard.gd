extends PanelContainer

var gem = null
onready var main = get_node('/root/Main')

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.target = self

func _on_Area2D_area_exited(area):
	if area.get_parent().is_in_group('cursor') and main.cursor != null:
		main.cursor.target = null
