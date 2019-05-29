extends Area2D
class_name Hitbox

signal hitbox_entered(other_hitbox)
signal damaged_other(other_hitbox)
signal resisted(other_hitbox)

#Config
export(Enums.CollisionType) var TYPE = Enums.CollisionType.NPC
export(bool) var can_hit_multiple := false

#Damage details
export(int) var damage := 5
export(int) var knockback_time := 30
export(float) var knockback_speed := 150.0
export(int) var hitstun_time := 30

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

#signal helpers below. Utility functions for interaction objects to use

#notify this hitbox that it did damage
func notify_did_damage(hitbox : Hitbox) -> void:
	emit_signal("damaged_other", hitbox)

#notify this hitbox that it's damage was resisted
#used to let owner know to stop the attack or something
func notify_resisted(hitbox : Hitbox) -> void:
	emit_signal("notify_resisted", hitbox)

func on_collision(other : Hitbox) -> void:
	emit_signal("hitbox_entered", other)
