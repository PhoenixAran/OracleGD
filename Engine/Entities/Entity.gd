extends KinematicBody2D
class_name Entity

signal entity_hit
signal entity_marked_dead(entity)
signal entity_destroyed

export(int) var static_speed := 70
export(int) var friction := -500
export(int) var acceleration := 1500
export(String) var anim_state := "idle"
export(String) var anim_direction := "down"

onready var health := $Health as Health

var current_speed := 0
var current_friction := 0
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
func move(delta : float) -> void:
	move_and_slide(vector.normalized() * current_speed, Vector2())

func get_animation_key() -> String:
	return anim_state + anim_direction

func is_dead() -> bool:
	return _death_marked

func is_intangible() -> bool:
	return (current_knockback_time > 0 && current_intangibility_time < intangibility_time)

func in_hitstun() -> bool:
	return (hitstun_time > 0 && current_hitstun_time < hitstun_time)

func in_knockback() -> bool:
	return (knockback_time > 0 && current_knockback_time < knockback_time)

func destroy_entity() -> void:
	emit_signal("entity_destroyed", self)
	queue_free()

func enable(enabled : bool) -> void:
	set_physics_process(enabled)

func update_combat_variables():
	if is_intangible():
		current_intangibility_time += 1
	if in_hitstun():
		current_hitstun_time += 1
	if in_knockback():
		current_knockback_time += 1

func reset_combat_variables():
	hitstun_time = 0
	knockback_time = 0
	intangibility_time = 0
	
	current_intangibility_time = 0
	current_hitstun_time = 0
	current_knockback_time = 0
	current_knockback_speed = 0
	
func take_damage(value : int) -> int:
	var damage_value := value
	if (damage_value > 0):
    	health.take_damage(value)
	return damage_value
	
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
