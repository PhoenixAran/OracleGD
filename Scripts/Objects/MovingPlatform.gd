extends Node2D
class_name MovingPlatform, "res://Assets/Objects/moving_platform.png"

export(float) var speed := 3.0
export(float) var idle_duration = 1.0

onready var tween := $Tween as Tween
onready var area := $Area2D as Area2D

export(Vector2) var move_to := Vector2()
var follow := Vector2()
var riders := []

func _ready() -> void:
	var duration = move_to.length() / (speed * 16)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + idle_duration)
	tween.start()

func _physics_process(delta : float) -> void:
	var old_position := area.position
	area.position = area.position.linear_interpolate(follow, 0.075)
	for elem in riders:
		elem.position.x += (area.position.x - old_position.x)
		elem.position.y += (area.position.y - old_position.y)

func register_rider(rider : Node2D) -> void:
	riders.append(rider)

func unregister_rider(rider : Node2D) -> void:
	assert(riders.has(rider))
	riders.remove(riders.find(rider))