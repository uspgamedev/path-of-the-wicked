extends Node2D

const GEM_DB = preload('res://gems/gem_db.gd')

func get_empty_slot():
	for slot in self.get_children():
		if slot.gem == null:
			return slot
	return false

func add_gem_on_slot(slot, gem_id):
	var const_name = str('GEMS', gem_id)
	randomize()
	var gem = GEM_DB.get(const_name)[randi() % GEM_DB.get(const_name).size()].instance()
	slot.gem = gem
	slot.add_child(gem)
	gem.position = slot.offset
