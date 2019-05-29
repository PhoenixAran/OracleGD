extends AnimationPlayer
class_name EntityAnimationPlayer

export(bool) var auto_detect_change := true

onready var _parent := get_parent() as Entity

func _physics_process(delta : float) -> void:
	if auto_detect_change:
		var animation_key = _parent.get_animation_key()
		if !is_playing() || animation_key != current_animation:
			stop()
			play(animation_key)
