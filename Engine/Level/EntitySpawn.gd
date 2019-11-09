extends Node2D
class_name EntitySpawn

var packed_entity : PackedScene

func _ready() -> void:
	var child = get_children()[0]
	var scene_path : String = child.get("filename")
	child.queue_free()
	packed_entity = load(scene_path)

#Game Code
func spawn() -> Entity:
	var entity = packed_entity.instance() as Entity
	entity.transform = transform
	return entity
	#entity.connect("entity_destroyed", self, "_on_entity_destroyed")



#signal callbacks
func _on_entity_destroyed(entity : Entity):
	#TODO set item drop
	pass

