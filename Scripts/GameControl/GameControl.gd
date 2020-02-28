extends Node2D
class_name GameControl

enum ControlState {
	Paused,
	Playing
}

export(String) var initial_room := "Room1"
export(String) var player_path := "Player"

onready var level := $Level as Level
onready var hud_canvas := $CanvasLayer
onready var hud := $CanvasLayer/HUD as HUD
onready var animation_player = $ScreenAnimationPlayer


var player : Player
var control_state = ControlState.Playing
var font : DynamicFont = Globals.get_default_font()

func _ready() -> void:
	player = get_node(player_path)
	GameRefs.set_player(player)
	level.call_deferred("initialize_level", player, initial_room, null)
	hud.call_deferred("init_hud")

func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("pause") and not level.is_processing_room_event():
		match control_state:
			ControlState.Paused:
				player.enable(true)
				level.enable(true)
				control_state = ControlState.Playing
				update()
			ControlState.Playing:
				level.enable(false)
				player.enable(false)
				control_state = ControlState.Paused
				update()

func _draw():
	if control_state == ControlState.Paused:
		var camera = player.get_node("PlayerCamera")
		var pos = Vector2(camera.limit_left, camera.limit_top)
		draw_string(font, pos + Vector2(Globals.screen_width / 2 - 15, Globals.screen_height / 2), "PAUSED")
