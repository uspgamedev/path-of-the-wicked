extends Control

const GEM_DB = preload('res://gems/gem_db.gd')
const GEM_INFO = preload('res://gems/gem_info.gd')

onready var hud = get_node('../../')
onready var main = get_node('/root/Main')
onready var map = get_node('/root/Main/Map')

func get_empty_slot():
	for slot in self.get_children():
		if slot.gem == null:
			return slot
	return null

func add_gem_on_slot(slot, gem_type):
	var const_name = str('GEMS', gem_type)
	randomize()
	var gem = GEM_DB.get(const_name)[randi() % GEM_DB.get(const_name).size()].instance()
	slot.gem = gem
	slot.add_child(gem)
	gem.position = slot.offset

func add_gem_on_slot_by_input(gem_type):
	var gem_info = GEM_INFO.new()
	var slot = get_empty_slot()
	if slot and hud.gold >= gem_info.get_gem_price(gem_type):
		hud.update_gold(-gem_info.get_gem_price(gem_type))
		add_gem_on_slot(slot, gem_type)

func _input(event):
	if main.cursor == null and not map.is_dummy_towers_visible:
		if event.is_action_pressed('ui_buy_gem_type1'):
			add_gem_on_slot_by_input('1')
		elif event.is_action_pressed('ui_buy_gem_type2'):
			add_gem_on_slot_by_input('2')
		elif event.is_action_pressed('ui_buy_gem_type3'):
			add_gem_on_slot_by_input('3')
		elif event.is_action_pressed('ui_buy_gem_type4'):
			add_gem_on_slot_by_input('4')
		elif event.is_action_pressed('ui_buy_gem_type5'):
			add_gem_on_slot_by_input('5')
		elif event.is_action_pressed('ui_buy_gem_type6'):
			add_gem_on_slot_by_input('6')
