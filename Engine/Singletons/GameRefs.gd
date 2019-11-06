extends Node
#Autoload

#tile map that holds where ice and water tiles are located
var ground_tile_map : TileMap setget set_ground_tile_map, get_ground_tile_map

func get_ground_tile_map() -> TileMap:
	return ground_tile_map

func set_ground_tile_map(value : TileMap) -> void:
	ground_tile_map = value

