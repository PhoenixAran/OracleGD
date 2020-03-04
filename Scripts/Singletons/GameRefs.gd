#Autoload
extends Node


##Declarations

#tile map that holds where ice and water tiles are located
var ground_tile_map : TileMap setget set_ground_tile_map, get_ground_tile_map
#player entity 
var player : Player setget set_player, get_player
var current_room : Room setget set_current_room, get_current_room

##Methods
func set_ground_tile_map(value : TileMap) -> void:
	ground_tile_map = value

func get_ground_tile_map() -> TileMap:
	return ground_tile_map

func set_player(value : Player) -> void:
	player = value

func get_player() -> Player:
	return player

func get_player_equipment() -> Equipment:
	return player.get_equipment()

func set_current_room(room : Room) -> void:
	current_room = room

func get_current_room() -> Room:
	return current_room
