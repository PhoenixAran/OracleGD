extends KinematicBody2D
class_name Entity

signal entity_hit
signal entity_bumped
signal entity_immobilized
signal entity_marked_dead(entity)
signal entity_destroyed

#Enum import
const CollisionType = Enums.CollisionType

#Exports
export(int) var static_speed := 70
export(String) var anim_state := "idle"
export(String) var anim_direction := "down"

#declarations
var current_speed := 0
var current_friction := 0
var vector := Vector2()
var _death_marked := false
var external_force := Vector2.ZERO

#Nodes / Resources
onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var entity_sprite = $EntitySprite as EntitySprite
onready var combat := Combat.new() as Combat
onready var health := $Health as Health
onready var interactions := InteractionResolver.new()

#Godot API Callbacks
func _physics_process(delta : float) -> void:
    if _death_marked:
        if in_hitstun() and not in_knockback():
            destroy()

#Entity methods
func update_animation(force_update := false) -> void:
	var key := get_animation_key()
	if force_update or animation_player.current_animation != key:
		animation_player.play(key)

func update_movement() -> void:
	var linear_velocity := vector.normalized() * current_speed
	linear_velocity += external_force
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

func reset_combat_variables() -> void:
	combat.reset_combat_variables()

func reset_movement_variables() -> void:
	current_speed = static_speed
	vector = Vector2.ZERO

func add_external_force(external_vector : Vector2, magnitude : float) -> void:
	external_force += external_vector * magnitude

func remove_external_force(external_vector : Vector2, magnitude : float) -> void:
	external_force -= external_vector * magnitude

func destroy() -> void:
	emit_signal("entity_destroyed", self)
	queue_free()

func enable(enabled : bool) -> void:
	set_physics_process(enabled)

func set_vector_away(other_vector : Vector2) -> void:
	vector = global_position - other_vector

func set_intangibility(frames : int) -> void:
	combat.set_intangibility(frames)
	entity_sprite.set_modulate_time(frames)

func take_damage(damage_info : Dictionary) -> void:
	set_intangibility(15)
	combat.set_combat_variables(damage_info)
	health.take_damage(damage_info.damage)
	set_vector_away(damage_info.source_position)
	current_speed = damage_info.knockback_speed
	emit_signal("entity_hit")

func bump(speed : float, direction : Vector2, time : int) -> void:
	combat.knockback_time = time
	combat.current_knockback_speed = speed
	vector = direction
	emit_signal("entity_bumped")

func immobilize(time : int) -> void:
	combat.current_hitstun_time = time
	emit_signal("entity_immobilized")

func match_animation_direction(input_vector : Vector2) -> void:
	var direction := anim_direction
	if input_vector == Vector2(-1, -1) and direction != "up" and direction != "left":
		direction = "up"
	elif input_vector == Vector2(1, 1) and direction != "down" and direction != "right":
		direction = "down"
	elif input_vector == Vector2(1, -1) and direction != "up" and direction != "right":
		direction = "up"
	elif input_vector == Vector2(-1, 1) and direction != "down" and direction != "left":
		direction = "left"
	elif input_vector == Vector2(0, -1) and direction != "up":
		direction = "up"
	elif input_vector == Vector2(0, 1) and direction != "down":
		direction = "down"
	elif input_vector == Vector2(-1, 0) and direction != "left":
		direction = "left"
	elif input_vector == Vector2(1, 0) and direction != "right":
		direction = "right"
	anim_direction = direction

#signal callback responses
func _on_health_depleted(damage : int) -> void:
	collision_layer = 0
	emit_signal("entity_marked_dead", self)
	_death_marked = true
