extends State
class_name PlayerMove

var player : Entity
var sword : PlayerSword

func initialize(context) -> void:
	player = context as Entity
	player.current_speed = player.static_speed
	sword = player.get("sword")
	
func begin() -> void:
	player.anim_state = "move"

func update(delta : float):
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	player.match_animation_direction(input_vector)
	player.vector = input_vector
	if input_vector == Vector2.ZERO:
		_change_state("PlayerIdle")
	elif Input.is_action_just_pressed("attack"):
		player.vector = Vector2.ZERO
		_change_state(sword.get_use_state())
