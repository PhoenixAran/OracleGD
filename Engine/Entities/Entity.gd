extends KinematicBody2D
class_name Entity

signal entity_hit
signal entity_marked_dead(entity)
signal entity_destroyed(entity)

export(int) var static_speed := 0
export(String) var anim_state := "idle"
export(String) var anim_direction := "down"

onready var health := $Health as Health

var current_speed := 0
var vector := Vector2()
var _death_marked := false

#combat state variables
var current_intangibility_time := 0
var current_hitstun_time := 0
var current_knockback_time := 0
var current_knockback_speed := 0.0

#temporary storage for combat state mutation
var hitstun_time := 0
var knockback_time := 0
var intangibility_time := 0

#Godot API Callbacks
func _physics_process(delta : float) -> void:
    if _death_marked:
        if in_hitstun() && !in_knockback():
            destroy_entity()

#Entity methods
func destroy_entity():
	queue_free()

func is_intangible() -> bool:
	return (current_knockback_time > 0 && current_intangibility_time < intangibility_time)

func in_hitstun() -> bool:
	return (hitstun_time > 0 && current_hitstun_time < hitstun_time)

func in_knockback() -> bool:
	return (knockback_time > 0 && current_knockback_time < knockback_time)
	
func get_animation_key() -> String:
	return anim_state + anim_direction

func enable(enabled : bool) -> void:
	set_physics_process(enabled)

#signal callback responses
func _on_health_depleted(damage : int) -> void:
	set_collision_layer_bit(0, false)
	emit_signal("entity_marked_dead", self)
	_death_marked = true
