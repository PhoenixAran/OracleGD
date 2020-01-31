extends CombatEntity
class_name AntiFairy

#USE CIRCLE COLLIDER

#Movement is quite unique from other monsters
#therefore we will derive directly from Entity instead of monster


var rotating : int

func _ready() -> void:
	animation_player.call_deferred("play", "spinning")

func update_movement(delta : float) -> void:
	if rotating:
		rotation = lerp_angle(rotation, vector.angle(), 0.1)
		rotating -= 1
		return
	
	var col := move_and_collide(vector * current_speed * delta)
	var pos := position
	if not col:
		for i in 10:
			position = pos
			rotate(PI / 32)
			vector = vector.rotated(PI / 32)
			col = move_and_collide(vector.rotated(PI / 2) * 15)
			
			if col:
				vector = col.normal.rotated(PI / 2)
				rotation = vector.angle()
				break
	else: 
		vector = col.normal.rotated(PI / 2)
		rotation = vector.angle()
