extends Camera2D
class_name PlayerCamera

const tween_target_count := 4

signal tween_completed

onready var tween := $Tween as Tween

var tween_count := 0
var in_transition = false

func _ready() -> void:
	tween.connect("tween_completed", self, "_on_tween_completed")


func set_limits(room) -> void:
	in_transition = true
	var transition_length := 1.0
	var transition_type = Tween.EASE_IN
	var ease_type = Tween.TRANS_LINEAR
	
	tween_count = 0
	tween.interpolate_property(self, "limit_bottom", limit_bottom, room.get_limit_bottom(), transition_length, transition_type, ease_type)
	tween.interpolate_property(self, "limit_top", limit_top, room.get_limit_top(), transition_length, transition_type, ease_type)
	tween.interpolate_property(self, "limit_left", limit_left, room.get_limit_left(), transition_length, transition_type, ease_type)
	tween.interpolate_property(self, "limit_right", limit_right, room.get_limit_right(), transition_length, transition_type, ease_type)
	
	tween.start()
	
func force_set_limits(room) -> void:
	limit_bottom = room.get_limit_bottom()
	limit_top = room.get_limit_top()
	limit_left = room.get_limit_left()
	limit_right = room.get_limit_right()

func _on_tween_completed(other, key) -> void:
	tween_count += 1
	if tween_count == tween_target_count:
		in_transition = false
		tween_count = 0
		emit_signal("tween_completed")
