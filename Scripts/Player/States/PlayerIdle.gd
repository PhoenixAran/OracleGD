extends State
class_name PlayerIdle

var player : Entity


func initialize(context) -> void:
	player = context as Entity
	player.current_speed = player.static_speed

func begin() -> void:
	player.reset_combat_variables()
	player.anim_state = "idle"

func update(delta : float) -> void:
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1

	player.vector = input_vector
	player.match_animation_direction(input_vector)

	if Input.is_action_just_pressed("attack"):
		_change_state("PlayerAttack")
	elif input_vector != Vector2.ZERO:
		_change_state("PlayerMove")
		player.move()
