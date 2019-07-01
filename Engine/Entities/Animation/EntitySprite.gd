extends Sprite
class_name EntitySprite

export(Color, RGBA) var hit_color := Color(1, 1, 1, 0.35)
export(Color, RGBA) var default_color := Color(1, 1, 1, 1)

var modulating := false
var current_time := 0
var time := 0

func _physics_process(delta : float) -> void:
	if modulating: 
		if current_time <= time:		
			current_time += 1
		else:
			modulating = false
			current_time = 0
			time = 0
			set_self_modulate(default_color)

func set_modulate_time(frames : int) -> void:
	modulating = true
	current_time = 0
	time = frames
	set_self_modulate(hit_color)
