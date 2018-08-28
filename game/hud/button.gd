extends Button

onready var shop_button = get_node('../../ShopButton')
var gem_id

func _ready():
	if get_child(0).name != 'Tower':
		gem_id = int(get_child(0).name[8])
	else:
		gem_id = 7

func _on_Button_mouse_entered():
	self.self_modulate = Color(1, 1, 1, 1)

func _on_Button_mouse_exited():
	self.self_modulate = Color(.7, .7, .7, 1)

func _on_Button_button_down():
	shop_button._on_ShopButton_button_down()
	shop_button.pressed = false
