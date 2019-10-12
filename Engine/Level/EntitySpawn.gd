extends Node2D
class_name EntitySpawn

export(PackedScene) var packed_entity : PackedScene

func load_entity() -> Entity:
	var entity = packed_entity.instance() as Entity
	entity.transform = transform
	entity.connect("entity_destroyed", self, "_on_entity_destroyed")
	return entity


#signal callbacks
func _on_entity_destroyed(entity : Entity):
	#TODO set item drop
	pass
