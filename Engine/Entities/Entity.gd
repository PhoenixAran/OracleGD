extends KinematicBody2D
class_name Entity

#should be emitted after the combat variables are set
signal entity_hit
signal entity_bumped
signal entity_marked_dead(entity)
signal entity_destroyed
signal entity_immobilized

export(int) var static_speed := 70
export(String) var anim_state := "idle"
export(String) var anim_direction := "down"

var current_speed := 0
var current_friction := 0
var vector := Vector2()
var _death_marked := false

#temporary storage for external "forces"
var external_vector_force := Vector2.ZERO
var external_magnitude := 0

#Nodes / Resources
onready var health := $Health as Health
onready var combat := $Combat as Combat
var interactions := InteractionResolver.new()

#Godot API Callbacks
func _physics_process(delta : float) -> void:
    if _death_marked:
        if in_hitstun() && !in_knockback():
            destroy()

#Entity methods
func move(delta : float) -> void:
	var linear_velocity := vector.normalized() * current_speed
	linear_velocity += external_vector_force.normalized() * external_magnitude
	move_and_slide(linear_velocity, Vector2())

func get_animation_key() -> String:
	return anim_state + anim_direction

func is_dead() -> bool:
	return _death_marked

func is_intangible() -> bool:
	return combat.is_intangible()

func in_hitstun() -> bool:
	return combat.in_hitstun()
	
func in_knockback() -> bool:
	return combat.in_hitstun()

func destroy() -> void:
	emit_signal("entity_destroyed", self)
	queue_free()

func enable(enabled : bool) -> void:
	set_physics_process(enabled)

func reset_combat_variables() -> void:
	pass
	
func take_damage(damage_info : Dictionary) -> void:
	var damage_value : int = damage_info.damage
	if (damage_value > 0):
    	health.take_damage(damage_value)
	combat.current_intangibility_time = damage_info.intangibility_time
	combat.current_hitstun_time = damage_info.hitstun_time
	combat.current_knockback_speed = damage_info.knockback_speed
	combat.current_knockback_time = damage_info.knockback_time	
	emit_signal("entity_hit")

func bump(speed : float, direction : Vector2, time : int) -> void:
	combat.current_knockback_time = time
	combat.current_knockback_speed = speed
	vector = direction
	emit_signal("entity_bumped")

func immobilize(time : int) -> void:
	combat.current_hitstun_time = time
	emit_signal("entity_immobilized")

func match_animation_direction(input_vector : Vector2):
	var direction := anim_direction
	if input_vector == Vector2(-1, -1) && direction != "up" && direction != "left":
		direction = "up"
	elif input_vector == Vector2(1, 1) && direction != "down" && direction != "right":
		direction = "down"
	elif input_vector == Vector2(1, -1) && direction != "up" && direction != "right":
		direction = "up"
	elif input_vector == Vector2(-1, 1) && direction != "down" && direction != "left":
		direction = "left"
	elif input_vector == Vector2(0, -1) && direction != "up":
		direction = "up"
	elif input_vector == Vector2(0, 1) && direction != "down":
		direction = "down"
	elif input_vector == Vector2(-1, 0) && direction != "left":
		direction = "left"
	elif input_vector == Vector2(1, 0) && direction != "right":
		direction = "right"
	
	anim_direction = direction
	
#signal callback responses
func _on_health_depleted(damage : int) -> void:
	set_collision_layer_bit(0, false)
	emit_signal("entity_marked_dead", self)
	_death_marked = true
	
