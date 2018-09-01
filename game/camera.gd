extends Camera2D

export(bool) var free_camera = false

const SMALL_WINDOW = Vector2(960, 540)
const MAX_WINDOW_SIZE = Vector2(1920 - 160, 1080)

var init_pos = Vector2(0, 0)
var holding_cam = false
var _window_size = OS.window_size

func _ready():
	self.z_index = 2
	self.offset = Vector2(0, 0)
	self.zoom = Vector2(2, 2)
	get_node('HUD').rect_scale = Vector2(2, 2)
	OS.window_resizable = false

func _input(event):
	if event.is_action_pressed('ui_camera'):
		init_pos = get_viewport().get_mouse_position() + self.offset
		holding_cam = true
	elif event.is_action_released('ui_camera'):
		holding_cam = false
	elif event.is_action_pressed('ui_zoom_in'):
		OS.window_size = _window_size
		OS.window_resizable = true
		if self.zoom != Vector2(1, 1):
			self.zoom = Vector2(1, 1)
			get_node('HUD').rect_scale = Vector2(1, 1)
			self.offset = get_viewport().get_mouse_position()
	elif event.is_action_pressed('ui_zoom_out') and OS.window_size <= SMALL_WINDOW:
		self.offset = Vector2(0, 0)
		self.zoom = Vector2(2, 2)
		get_viewport().warp_mouse(get_viewport().get_mouse_position())
		get_node('HUD').rect_scale = Vector2(2, 2)
		OS.window_resizable = false

func _physics_process(delta):
	if holding_cam and self.zoom == Vector2(1, 1):
		change_camera_pos()
	if not free_camera:
		self.offset = Vector2(min(self.offset.x, MAX_WINDOW_SIZE.x - OS.window_size.x), \
		                      min(self.offset.y, MAX_WINDOW_SIZE.y - OS.window_size.y))
		_window_size = Vector2(min(OS.window_size.x, MAX_WINDOW_SIZE.x), \
		                           min(OS.window_size.y, MAX_WINDOW_SIZE.y))
		if OS.window_size != _window_size:
			OS.window_resizable = false
			OS.window_size = _window_size
			self.offset.x = 0

func change_camera_pos():
	var cur_pos = get_viewport().get_mouse_position()
	var cur_offset = init_pos - cur_pos
	if not free_camera:
		if cur_offset.x < 0 or cur_offset.x + OS.window_size.x> MAX_WINDOW_SIZE.x:
			init_pos = Vector2(cur_pos.x + self.offset.x, init_pos.y)
		if cur_offset.y < 0 or cur_offset.y + OS.window_size.y > MAX_WINDOW_SIZE.y:
			init_pos = Vector2(init_pos.x, cur_pos.y + self.offset.y)
		cur_offset = Vector2(min(max(0, cur_offset.x), MAX_WINDOW_SIZE.x - OS.window_size.x), \
		                     min(max(0, cur_offset.y), MAX_WINDOW_SIZE.y - OS.window_size.y))
	self.offset = Vector2(cur_offset)
