extends Camera2D

const SMALL_WINDOW = Vector2(960, 540)
const MAX_WINDOW_SIZE = Vector2(1920, 1080)

var init_pos
var holding_cam = false

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed('ui_camera'):
		init_pos = get_viewport().get_mouse_position() + self.offset
		holding_cam = true
	elif event.is_action_released('ui_camera'):
		holding_cam = false
	elif event.is_action_pressed('ui_zoom_in'):
		if self.zoom != Vector2(1, 1):
			self.zoom = Vector2(1, 1)
			OS.window_resizable = true
			self.offset = get_viewport().get_mouse_position()
	elif event.is_action_pressed('ui_zoom_out'):
		if OS.window_size <= SMALL_WINDOW:
			self.offset = Vector2(0, 0)
			self.zoom = Vector2(2, 2)
			OS.window_resizable = false

func _process(delta):
	if holding_cam and self.zoom == Vector2(1, 1):
		change_camera_pos()
	self.offset = Vector2(min(self.offset.x, MAX_WINDOW_SIZE.x - OS.window_size.x), \
	                      min(self.offset.y, MAX_WINDOW_SIZE.y - OS.window_size.y))
	OS.window_size = Vector2(min(OS.window_size.x, MAX_WINDOW_SIZE.x), 
	                         min(OS.window_size.y, MAX_WINDOW_SIZE.y))

func change_camera_pos():
	var cur_pos = get_viewport().get_mouse_position()
	var cur_offset = init_pos - cur_pos
	if cur_offset.x < 0 or cur_offset.x + OS.window_size.x> MAX_WINDOW_SIZE.x:
		init_pos = Vector2(cur_pos.x + self.offset.x, init_pos.y)
	if cur_offset.y < 0 or cur_offset.y + OS.window_size.y > MAX_WINDOW_SIZE.y:
		init_pos = Vector2(init_pos.x, cur_pos.y + self.offset.y)
	cur_offset = Vector2(min(max(0, cur_offset.x), MAX_WINDOW_SIZE.x - OS.window_size.x), \
	                     min(max(0, cur_offset.y), MAX_WINDOW_SIZE.y - OS.window_size.y))
	self.offset = Vector2(cur_offset.x, cur_offset.y)
