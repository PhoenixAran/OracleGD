extends Area2D
class_name Hitbox

signal on_damage_other
signal on_damage_resisted

onready var _owner := get_parent() as Node2D

export(bool) var _use_parent_as_source := false
export(bool) var can_hit_multiple := true
export(int) var damage := 5
export(float) var knockback_speed := 30.0
export(int) var knockback := 30
export(int) var hitstun := 30
export(int) var reflect_value := 0

func _physics_process(delta : float) -> void:
	for i in range(100):
		create_damage_response(15)
	check_collisions()

func check_collisions() -> void:
	var areas := get_overlapping_areas()
	if areas.size() > 0:
		if can_hit_multiple:
			for area in areas:
				area.take_damage(self)
		else:
			areas[0].take_damage(self)

func get_damage_source() -> Vector2:
	if _use_parent_as_source:
		return _owner.global_position
	return self.global_position

func take_damage(hitbox : Hitbox) -> Dictionary:
	return create_damage_response(hitbox.damage, self.reflect_value, false)

func create_damage_response(damage_taken : int, reflect_response := 0, resist := false) -> Dictionary:
	return {
		damage_taken : damage_taken,
		reflect_response : reflect_response,
		resist : resist
	}
