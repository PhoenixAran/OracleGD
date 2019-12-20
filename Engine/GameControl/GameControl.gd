extends Node
class_name GameControl

export(String) var initial_room := "Room1"
export(String) var player_path := "Player"

onready var level := $Level as Level
onready var hud := $CanvasLayer/HUD as HUD


var player : Player

func _ready() -> void:
	player = get_node(player_path) as Player
	GameRefs.set_player(player)
	level.call_deferred("initialize_level", player, initial_room, null)
	hud.call_deferred("init_hud")

