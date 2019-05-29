extends Area2D
class_name Hitbox

signal hitbox_entered(other_hitbox)
signal damaged_other(other_hitbox)
signal resisted(other_hitbox)

#Config
export(Enums.CollisionType) var TYPE = Enums.CollisionType.NPC
export(bool) var can_hit_multiple := false
export(bool) var detect_only setget set_detect_only

#Damage details
export(int) var damage := 5
export(int) var knockback_time := 30
export(float) var knockback_speed := 150.0
export(int) var hitstun_time := 30

func _ready() -> void:
	if detect_only:
		set_physics_process(false)

func _physics_process(delta : float) -> void:
	check_collisions()
		
func set_detect_only(value : bool) -> void:
	if detect_only != value:
		detect_only = value
		set_physics_process(!detect_only)

func check_collisions() -> void:
	var areas := get_overlapping_areas()
	if areas.size() > 0:
		if can_hit_multiple:
			for area in areas:
				(area as Hitbox).report_collision(self)
		else:
			(areas[0] as Hitbox).report_collision(self)
			
#raises the hitbox hitbox_entered signal
func report_collision(hitbox : Hitbox):
	emit_signal("hitbox_entered", hitbox)

#signal helpers below. Utility functions for interaction objects to use
#notify this hitbox that it did damage
func notify_did_damage(hitbox : Hitbox) -> void:
	emit_signal("damaged_other", hitbox)

#notify this hitbox that it's damage was resisted
#used to let owner know to stop the attack or something
func notify_resisted(hitbox : Hitbox) -> void:
	emit_signal("notify_resisted", hitbox)
