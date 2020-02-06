extends KinematicBody2D
class_name Entity

signal entity_destroyed(entity)
signal projectile_created(entity)
signal entity_created(entity)

#Enum import
const CollisionType = Enums.CollisionType

#declarations
export(int) var static_speed := 70
export(float) var static_acceleration = 1.0
export(float) var static_deceleration = 1.0
export(String) var anim_state := "idle"
export(String) var anim_direction := "down"

var target_speed := 0.0
var current_speed := 0.0
var current_friction := 0.0
var current_acceleration : float
var current_deceleration : float
var vector := Vector2() setget set_vector, get_vector
var external_force := Vector2()

var cached_counter_vector : Vector2
var cached_counter_speed : float

#Nodes / Resources
onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var entity_sprite = $EntitySprite as EntitySprite

#Godot API
func _ready() -> void:
	target_speed = static_speed
	current_acceleration = static_acceleration
	current_deceleration = static_deceleration

#Entity methods
func set_vector(value : Vector2) -> void:
	if value != Vector2.ZERO:
		cached_counter_vector = vector
		cached_counter_speed = current_speed
	vector = value

func get_vector() -> Vector2:
	return vector

func update_animation(force_update := false) -> void:
	var key := get_animation_key()
	if force_update or animation_player.current_animation != key:
		animation_player.play(key)

func get_linear_velocity(delta : float) -> Vector2:
	var linear_velocity : Vector2
	if get_vector() == Vector2.ZERO:
		current_speed -= target_speed * current_deceleration
		if current_speed < 0:
			current_speed = 0
		linear_velocity = cached_counter_vector.normalized() * current_speed
	else:
		current_speed += target_speed * current_acceleration
		if current_speed > target_speed:
			current_speed = target_speed
		linear_velocity = get_vector().normalized() * current_speed
		
		if cached_counter_vector != get_vector():
			cached_counter_speed -= static_speed * current_deceleration
			if cached_counter_speed < 0:
				cached_counter_speed = 0
			linear_velocity += cached_counter_vector.normalized() * cached_counter_speed
		
	linear_velocity += external_force
	return linear_velocity

func recalculate_linear_velocity(delta : float, new_vector : Vector2) -> Vector2:
	var linear_velocity : Vector2
	var old_vector := get_vector()
	if new_vector == old_vector:
		push_warning("Warning: Trying to recalculate linear velocity with the same vector!")

	if old_vector == Vector2.ZERO:
		linear_velocity = cached_counter_vector.normalized() * current_speed
	else:
		linear_velocity = new_vector.normalized() * current_speed
		
		if cached_counter_vector != new_vector:
			linear_velocity += cached_counter_vector.normalized() * cached_counter_speed
	linear_velocity += external_force
	set_vector(new_vector)
	return linear_velocity

func update_movement(delta : float) -> Vector2:
	var linear_velocity := get_linear_velocity(delta)
	return move_and_slide(linear_velocity, Vector2())

func get_animation_key() -> String:
	return anim_state + anim_direction

func reset_movement_variables() -> void:
	target_speed = static_speed
	current_speed = 0.0
	vector = Vector2.ZERO
	current_acceleration = static_acceleration
	current_deceleration = static_deceleration

func clear_counter_vector_and_speed() -> void:
	cached_counter_speed = 0.0
	cached_counter_vector = Vector2.ZERO

func reset_external_force() -> void:
	external_force = Vector2.ZERO

func add_external_force(external_vector : Vector2, magnitude : float) -> void:
	external_force += external_vector * magnitude

func remove_external_force(external_vector : Vector2, magnitude : float) -> void:
	external_force -= external_vector * magnitude

func destroy() -> void:
	emit_signal("entity_destroyed", self)
	queue_free()

func enable(enabled : bool) -> void:
	set_physics_process(enabled)

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
