extends Area2D
class_name DynamicTile

signal dynamic_tile_destroyed(dynamic_tile)

export(Enums.TileType) var tile_type

func get_tile_type():
	return tile_type

func destroy() -> void:
	emit_signal("dynamic_tile_destroyed", self)
	queue_free()
