extends Button

const GEM_INFO = preload('res://gems/gem_info.gd')

onready var hud = get_node('../../../')
onready var shop_button = get_node('../../ShopButton')
onready var inventory = get_node('../../Inventory')
onready var main = get_node('/root/Main')
onready var gem_info = GEM_INFO.new()

var item

func _ready():
	item = get_child(0)

func _on_Button_mouse_entered():
	self.self_modulate = Color(1, 1, 1, 1)
	if not item.is_in_group('tower'):
		hud.set_popup_text(str('Type: ', item.type, '\n\nDamage: ', \
		                   item.dmg, '\n\nPrice: ', item.price))
	else:
		hud.set_popup_text(str(item.name, '\n\nRange: ', \
		                   item.radius, '\n\nPrice: ', item.price))
	hud.show_popup(self.rect_position)

func _on_Button_mouse_exited():
	self.self_modulate = Color(.7, .7, .7, 1)
	hud.hide_popup()

func button_down():
	shop_button._on_ShopButton_button_down()
	shop_button.pressed = false
	hud.hide_popup()
	get_viewport().warp_mouse(get_viewport().get_mouse_position())

func _on_Button_button_down():
	if hud.gold >= item.price:
		if item.is_in_group('tower'):
			main.get_node('Map').show_tower_phs()
			button_down()
		else:
			var slot = inventory.get_empty_slot()
			if slot:
				button_down()
				hud.update_gold(-item.price)
				inventory.add_gem_on_slot(slot, item.type)
