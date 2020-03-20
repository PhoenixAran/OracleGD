#InputHelper.gd
extends Node

func poll_direction_input() -> Vector2:
	var input_vector := Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	return input_vector

func poll_4_way_direction_input() -> Vector2:
	var input_vector = poll_direction_input()
	
	if input_vector == Vector2(-1, -1):
		input_vector = Vector2.UP
	elif input_vector == Vector2(1, 1):
		input_vector = Vector2.DOWN
	elif input_vector == Vector2(1, -1):
		input_vector = Vector2.RIGHT
	elif input_vector == Vector2(-1, 1):
		input_vector = Vector2.LEFT
	
	return input_vector
