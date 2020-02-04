tool
extends Node2D
class_name EntitySpawn

signal collectable_dropped(collectable)

export(PackedScene) var packed_entity setget set_packed_entity
export(Dictionary) var entity_params : Dictionary
#tool variables, won't be used in game
export(String) var sprite_path := "EntitySprite" setget set_sprite_path
export(Rect2) var editor_src_rect := Rect2(0, 0, 16, 16) setget set_editor_src_rect

func _draw() -> void:
	if Engine.is_editor_hint() and packed_entity:
		var temp_entity : Node = packed_entity.instance()
		var entity_sprite : Sprite = temp_entity.get_node_or_null(sprite_path)
		if entity_sprite:
			var temp_texture = entity_sprite.texture
			var destination_rect := Rect2(0 - (editor_src_rect.size.x / 2), 0 - (editor_src_rect.size.y / 2), editor_src_rect.size.x, editor_src_rect.size.y)
			draw_texture_rect_region(temp_texture, destination_rect, editor_src_rect)
		else:
			print("Cannot find node EntitySprite for node")
		temp_entity.queue_free()

func set_packed_entity(value) -> void:
	packed_entity = value
	if Engine.is_editor_hint():
		update()

func set_editor_src_rect(new_rect) -> void:
	editor_src_rect = new_rect
	if Engine.is_editor_hint():
		update()

func set_sprite_path(path) -> void:
	sprite_path = path
	if Engine.is_editor_hint():
		update()

func spawn() -> Entity:
	var entity : Entity = packed_entity.instance()
	entity.transform = transform
	for key in entity_params.keys():
		entity.set(key, entity_params[key])
	return entity
