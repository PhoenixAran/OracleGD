extends Camera2D
class_name PlayerCamera

signal position_tween_completed

onready var tween := $Tween as Tween

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_completed")

func set_limits(room) -> void:
	var transition_length := 1.0
	var transition_type = Tween.EASE_IN
	var ease_type = Tween.TRANS_LINEAR
	
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

func _on_tween_completed() -> void:
	print("hello")
	emit_signal("position_tween_completed")
