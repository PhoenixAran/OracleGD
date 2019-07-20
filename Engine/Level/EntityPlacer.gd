extends TileMap
class_name EntityPlacer

signal entity_created(entity)

func _ready() -> void:
	set_visible(false)

func has_entity(x : int, y : int) -> bool:
	 return get_cell(x, y) != -1

func spawn_entity(x : int, y : int) -> Entity:
	var cell_id : int = get_cell(x, y)
	assert(cell_id != -1)
	var offset : Vector2 = cell_size / 2
	var packed_scene = load("res://Scenes/Monsters/" + tile_set.tile_get_name(cell_id) + ".tscn")
	var entity := packed_scene.instance() as Entity
	entity.global_position = Vector2(x * cell_size.x, y * cell_size.y) + offset
	emit_signal("entity_created", entity)
	return entity

