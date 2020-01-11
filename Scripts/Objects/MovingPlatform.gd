extends Node2D
class_name MovingPlatform, "res://Assets/Objects/moving_platform.png"

enum LoopType {
	Cycle,
	PingPong
}

export(float) var speed := 3.0
export(float) var idle_duration = 1.0
export(LoopType) var loop_type = LoopType.PingPong
export(Array, Vector2) var positions := []

onready var tween := $Tween as Tween
onready var area := $Area2D as Area2D

var follow := Vector2()
var riders := []
var position_index := 0

func _ready() -> void:
	if not positions.empty():
		positions.push_back(Vector2(0, 0))
		tween.connect("tween_completed", self, "_on_tween_completed")
		var unit_vector = Vector2(positions[0].x * Globals.unit_size, positions[0].y * Globals.unit_size)
		var duration = unit_vector.length() / (speed * Globals.unit_size)
		tween.interpolate_property(self, "follow", Vector2.ZERO, unit_vector, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
		tween.call_deferred("start")

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

func _on_tween_completed(object, key) -> void:
	var old_index := position_index
	var old_unit_vector = Vector2(positions[old_index].x * Globals.unit_size, positions[old_index].y * Globals.unit_size)
	match loop_type:
		LoopType.Cycle:
			position_index = (position_index + 1) % positions.size()
		LoopType.PingPong:
			if position_index < positions.size():
				position_index += 1
			else:
				position_index -= 1
	var new_position = positions[position_index]
	var unit_vector = Vector2(new_position.x * Globals.unit_size, new_position.y * Globals.unit_size)
	var duration = (old_unit_vector - unit_vector).length() / (speed * Globals.unit_size)
	print(old_unit_vector)
	tween.interpolate_property(self, "follow", follow, unit_vector , duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	tween.call_deferred("start")
