extends Area2D
class_name Hitbox

signal on_damage_other
signal on_damage_resisted

onready var _owner := get_parent() as Node2D

export(bool) var use_parent_as_source := false
export(bool) var can_hit_multiple := true
export(int) var damage := 5
export(float) var knockback_speed := 30.0
export(int) var knockback := 30
export(int) var hitstun := 30
export(int) var reflect_value := 0

func _physics_process(delta : float) -> void:
	check_collisions()

func check_collisions() -> void:
	var areas := get_overlapping_areas()
	if areas.size() > 0:
		var source = _owner.global_position if use_parent_as_source else self.global_position
		if can_hit_multiple:
			for area in areas:
				var response := (area as Hitbox).take_damage(self, source)
		else:
			(areas[0] as Hitbox).take_damage(self, source)
        
func take_damage(hitbox : Hitbox, source : Vector2) -> DamageResponse:
	var response := DamageResponse.new()
	response.create(hitbox.damage, reflect_value)
	return response