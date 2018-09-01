extends Control

onready var wave_manager = get_node('/root/Main/WaveManager')
onready var next_wave = get_node('NextWave')

func start_countdown():
	var tween = get_node('NextWave/Tween')
	var bar = get_node('NextWave/TextureProgress')
	next_wave.visible = true
	tween.interpolate_property(bar, 'value', 0, 100, 15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_NotificationsTimer_timeout():
	var notif = get_node('Notifications')
	var notif_tween = get_node('Notifications/Tween')
	notif_tween.interpolate_property(notif, 'modulate', \
	            Color(1, 1, 1, 1), Color(1, 1, 1, 0), .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	notif_tween.start()
	start_countdown()

func _on_Tween_tween_completed(object, key):
	next_wave.visible = false
	wave_manager.start_wave()
