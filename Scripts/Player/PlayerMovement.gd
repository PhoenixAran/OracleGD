extends Node
class_name PlayerMovement

export(float) var speed := 70.0 setget set_speed, get_speed
export(bool) var slippery := false setget set_slippery, is_slippery
export(float) var acceleration = 1.0 setget set_acceleration, get_acceleration
export(float) var deceleration = 1.0 setget set_deceleration, get_deceleration

func get_speed() -> float:
	return speed

func set_speed(value : float) -> void:
	speed = value

func set_slippery(value : bool) -> void:
	slippery = value

func is_slippery() -> bool:
	return slippery

func get_acceleration() -> float:
	return acceleration

func set_acceleration(value : float) -> void:
	acceleration = value

func get_deceleration() -> float:
	return deceleration

func set_deceleration(value : float) -> void:
	deceleration = value
