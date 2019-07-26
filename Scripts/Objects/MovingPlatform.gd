extends Area2D
class_name MovingPlatform, "res://Assets/Objects/moving_platform.png"

export(Dictionary) var move_points : Dictionary

onready var tween := $Tween as Tween

var cached_velocity := 0.0
var cached_direction := Vector2()
var target_point := Vector2()






