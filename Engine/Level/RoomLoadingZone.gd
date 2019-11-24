extends Area2D
class_name RoomLoadingZone

const RoomTransitionType = Enums.RoomTransitionType
const Direction = Enums.Direction

export(RoomTransitionType) var transition_type
export(Direction) var direction

signal loading_zone_activated(room_event)

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(other) -> void:
	emit_signal("loading_zone_activated", get_transition_event())


func get_transition_event() -> RoomEvent:
	var room_event : PushTransition = null
	match transition_type:
		RoomTransitionType.PUSH:
			var push_transition : PushTransition = PushTransition.new()
			push_transition.direction = direction
			room_event = push_transition
	assert(room_event != null)
	return room_event
