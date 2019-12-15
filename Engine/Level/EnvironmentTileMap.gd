extends TileMap
class_name EnvironmentTileMap

func get_colliding_tile_id(pos : Vector2) -> int:
	return get_cellv(world_to_map(pos))
