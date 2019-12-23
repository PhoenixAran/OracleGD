tool
extends Node2D
class_name EntitySpawn

export(PackedScene) var packed_entity setget set_packed_entity
export(Rect2) var editor_src_rect := Rect2(0, 0, 16, 16) setget set_editor_src_rect
#tool variables, won't be used in game

func _ready() -> void:
	if Engine.is_editor_hint():
		pass

func _draw() -> void:
	if Engine.is_editor_hint() and packed_entity:
		var temp_entity = packed_entity.instance()
		var entity_sprite : EntitySprite = temp_entity.get_node_or_null("EntitySprite")
		if entity_sprite:
			var temp_texture := entity_sprite.texture
			var destination_rect := Rect2(0 - (editor_src_rect.size.x / 2), 0 - (editor_src_rect.size.y / 2), editor_src_rect.size.x, editor_src_rect.size.y)
			draw_texture_rect_region(temp_texture, destination_rect, editor_src_rect)
		else:
			print("Cannot find node EntitySprite for node")
		temp_entity.queue_free()

func set_packed_entity(value) -> void:
	packed_entity = value
	if Engine.is_editor_hint():
		#request redraw
		update()

func set_editor_src_rect(new_rect) -> void:
	editor_src_rect = new_rect
	if Engine.is_editor_hint():
		update()
		
func spawn() -> Entity:
	var entity : Entity = packed_entity.instance()
	entity.transform = transform
	return entity
