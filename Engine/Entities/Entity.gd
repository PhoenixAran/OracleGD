extends KinematicBody2D
class_name Entity

signal entity_destroyed(entity)
signal projectile_created(entity)
signal entity_created(entity)

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
var external_force := Vector2.ZERO

#Nodes / Resources
onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var entity_sprite = $EntitySprite as EntitySprite

#Godot API
func _ready() -> void:
	current_speed = static_speed

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