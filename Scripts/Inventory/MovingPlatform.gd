extends Node2D
class_name MovingPlatform, "res://Assets/Objects/moving_platform.png"

enum LoopType {
	Cycle,
	PingPong
}

enum PingPongState {
	Forward,
	Backward
}

export(float) var speed := 3.0
export(float) var idle_duration = 1.0
export(LoopType) var loop_type = LoopType.Cycle
export(Array, Vector2) var positions := []

onready var tween := $Tween as Tween
onready var area := $Area2D as Area2D

var follow := Vector2()
var riders := []
var position_index := 1
var ping_pong_state = PingPongState.Forward

func _ready() -> void:
	if not positions.empty():
		if not positions.front() == Vector2.ZERO:
			positions.push_front(Vector2.ZERO)
		tween.connect("tween_completed", self, "_on_tween_completed")
		var unit_vector = Vector2(positions[1].x * Globals.unit_size, positions[1].y * Globals.unit_size)
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
			match ping_pong_state:
				PingPongState.Forward:
					if position_index < positions.size() - 1:
						position_index += 1
					elif position_index == positions.size() - 1:
						position_index -= 1
						ping_pong_state = PingPongState.Backward
				PingPongState.Backward:
					if position_index > 0:
						position_index -= 1
					elif position_index == 0:
						position_index =+ 1
						ping_pong_state = PingPongState.Forward
	var new_position = positions[position_index]
	var unit_vector = Vector2(new_position.x * Globals.unit_size, new_position.y * Globals.unit_size)
	var duration = (old_unit_vector - unit_vector).length() / (speed * Globals.unit_size)
	tween.interpolate_property(self, "follow", follow, unit_vector , duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle_duration)
	tween.call_deferred("start")
