extends Node
class_name GameControl

export(String) var initial_room := "Room1"
export(String) var player_path := "Player"

onready var level := $Level as Level

var player : Player

func _ready() -> void:
	player = get_node(player_path) as Player
	level.call_deferred("initialize_level", player, initial_room, null)
	GameRefs.set_player(player)
	