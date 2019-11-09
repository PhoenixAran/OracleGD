#Autoload
extends Node
##This singleton will help translate Ground Tile ID to enum tile type
##This will be used in the EnvironmentalCollisionBox class to determine 
##tile collisions

var _tile_dictionary = {
	-1 : Enums.TileType.GROUND,
	0 : Enums.TileType.GROUND,
	1: Enums.TileType.SHALLOW_WATER,
	2: Enums.TileType.DEEP_WATER,
	3: Enums.TileType.HOLE,
	4: Enums.TileType.LAVA,
	5: Enums.TileType.LADDER
}


func get_tile_type(id : int):
	return _tile_dictionary[id]
