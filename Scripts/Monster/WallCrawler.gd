extends Monster
class_name WallCrawler

#USE CIRCLE COLLIDER

export(bool) var has_default_animation := true
export(String) var default_animation : String

func _ready() -> void:
	if has_default_animation:
		animation_player.call_deferred("play", default_animation)
	set_deferred("current_speed", 50)

func get_animation_key() -> String:
	return default_animation

func update_movement(delta : float) -> void:
	var col := move_and_collide(vector * 50 * delta)
	if col and col.normal.rotated(PI / 2).dot(vector) < 0.5:
		vector = col.normal.rotated(PI / 2)
		return
	
	var pos := position
	col = move_and_collide(vector.rotated(PI / 2) * 3.5)
	if not col:
		for i in 10:
			position = pos
			vector = vector.rotated(PI / 32)
			col = move_and_collide(vector.rotated(PI / 2) * 3.5)
			
			if col:
				vector = col.normal.rotated(PI / 2)
				break
	else:
		vector = col.normal.rotated(PI / 2)
