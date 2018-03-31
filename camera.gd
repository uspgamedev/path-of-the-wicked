extends Camera2D

var init_pos
var holding_cam = false
var cur_window_size = OS.window_size

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	if (event.is_action_pressed('ui_camera')):
		init_pos = get_viewport().get_mouse_position() + self.offset
		holding_cam = true
	elif (event.is_action_released('ui_camera')):
		holding_cam = false

func _process(delta):
	if (holding_cam):
		change_camera_pos()
	else:
		self.offset = OS.window_size/2

func change_camera_pos():
	var cur_pos = get_viewport().get_mouse_position()
	var init_offset = OS.window_size/2
	var cur_offset = init_pos - cur_pos
	if (cur_offset.x < init_offset.x):
		cur_offset = Vector2(512, cur_offset.y)
		init_pos = Vector2(cur_pos.x + self.offset.x, init_pos.y)
	if (cur_offset.y < init_offset.y):
		cur_offset = Vector2(cur_offset.x, 300)
		init_pos = Vector2(init_pos.x, cur_pos.y + self.offset.y)
	self.offset = Vector2(cur_offset.x, cur_offset.y)
