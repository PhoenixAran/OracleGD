extends State
class_name PlayerMove

var player : Entity

func initialize() -> void:
	player = get_node("../../") as Entity
	player.current_speed = player.static_speed
	
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
	
	player.vector = input_vector
	player.match_animation_direction(input_vector)
	if input_vector == Vector2.ZERO:
		_change_state("PlayerIdle")
	
