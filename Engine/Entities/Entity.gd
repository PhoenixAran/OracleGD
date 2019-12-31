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

var speed := 0.0
var current_speed := 0.0
var current_friction := 0.0
var acceleration : float
var deceleration : float
var vector := Vector2() setget set_vector, get_vector
var external_force := Vector2()

var _cached_vector : Vector2
var _cached_speed : float

#Nodes / Resources
onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var entity_sprite = $EntitySprite as EntitySprite

#Godot API
func _ready() -> void:
	speed = static_speed
	acceleration = static_acceleration
	deceleration = static_deceleration

#Entity methods
func set_vector(value : Vector2) -> void:
	if value != Vector2.ZERO:
		_cached_vector = vector
		_cached_speed = current_speed
	vector = value

func get_vector() -> Vector2:
	return vector

func update_animation(force_update := false) -> void:
	var key := get_animation_key()
	if force_update or animation_player.current_animation != key:
		animation_player.play(key)

func update_movement(delta : float) -> void:
	var linear_velocity : Vector2
	if get_vector() == Vector2.ZERO:
		current_speed -= speed * deceleration
		if current_speed < 0:
			current_speed = 0
		linear_velocity = _cached_vector.normalized() * current_speed
	else:
		current_speed += speed * acceleration
		if current_speed > speed:
			current_speed = speed
		linear_velocity = get_vector().normalized() * current_speed
		
		if _cached_vector != get_vector():
			_cached_speed -= static_speed * deceleration
			if _cached_speed < 0:
				_cached_speed = 0
			linear_velocity += _cached_vector.normalized() * _cached_speed
		
	linear_velocity += external_force
	move_and_slide(linear_velocity, Vector2())

func get_animation_key() -> String:
	return anim_state + anim_direction

func reset_movement_variables() -> void:
	speed = static_speed
	current_speed = 0.0
	vector = Vector2.ZERO
	acceleration = static_acceleration
	deceleration = static_deceleration
	_cached_speed = 0.0
	_cached_vector = Vector2.ZERO

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
