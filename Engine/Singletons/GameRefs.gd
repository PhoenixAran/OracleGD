#Autoload
extends Node


##Declarations

#tile map that holds where ice and water tiles are located
var ground_tile_map : TileMap setget set_ground_tile_map, get_ground_tile_map
#player entity 
var player : Player setget set_player, get_player


##Methods
func set_ground_tile_map(value : TileMap) -> void:
	ground_tile_map = value

func get_ground_tile_map() -> TileMap:
	return ground_tile_map

func set_player(value : Player) -> void:
	player = value

func get_player() -> Player:
	return player


