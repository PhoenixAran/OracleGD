extends Area2D
class_name Hitbox

signal hitbox_entered(hitbox, response)

export(bool) var can_hit_multiple := false
export(bool) var can_be_reflected := false

export(int) var damage := 5
export(int) var knockback_time := 30
export(float) var knockback_speed := 150.0
export(int) var hitstun_time := 30
export(int) var reflect_value := 0
export(int) var reflect_resistance := 0
#used to flip enemies upside down or break stuff
export(int) var force := 0

onready var parent := get_parent() as Node2D

func _physics_process(delta : float) -> void:
	check_collisions()

func check_collisions() -> void:
	var areas := get_overlapping_areas()
	if areas.size() > 0:
		if can_hit_multiple:
			for area in areas:
				on_collision((area as Hitbox))
		else:
			on_collision((areas[0] as Hitbox))

func on_collision(other : Hitbox) -> void:
	var response := other.take_damage(self)
	emit_signal("hitbox_entered", other, response)

func take_damage(other : Hitbox) -> Dictionary:
	return _create_damage_response(0, reflect_value, false)

#creates a damage response dictionary. Easier than manually creating each key
func _create_damage_response(damage_taken := 0, reflect_value := 0,
 		resist := false, recoil := false) -> Dictionary:
	return {
		damage_taken = damage_taken,
		reflect_value = reflect_value,
		resist = resist,
		recoil = recoil
	}
