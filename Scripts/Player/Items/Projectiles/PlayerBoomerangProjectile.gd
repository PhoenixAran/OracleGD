extends KinematicBody2D
class_name PlayerBoomerangProjectile

enum BoomerangState {
	INACTIVE,
	MOVING,
	RETURNING
}

signal returned_to_owner

export(float) var speed := 80.0
export(int) var return_delay := 45

onready var anim_player := $AnimationPlayer as AnimationPlayer
onready var hitbox := $Hitbox as Hitbox
onready var interactions := InteractionResolver.new() as InteractionResolver

var vector := Vector2()
var state = BoomerangState.INACTIVE
var return_timer := 0
var owner_node : Node2D

func _ready() -> void:
	hitbox.connect("damaged_other", self, "_on_damaged_other")

func set_owner_node(value : Node2D) -> void:
	owner_node = value

func throw(input_vector : Vector2) -> void:
	vector = input_vector.normalized()
	begin_moving_state()
	anim_player.play("rotating")

func _physics_process(delta : float) -> void:
	match state:
		BoomerangState.INACTIVE:
			pass
		BoomerangState.MOVING:
			update_moving_state()
		BoomerangState.RETURNING:
			update_return_state()

func enable(value : bool) -> void:
	if value:
		anim_player.play()
	else:
		anim_player.stop()

func begin_moving_state() -> void:
	state = BoomerangState.MOVING

func update_moving_state() -> void:
	return_timer += 1
	if return_delay <= return_timer:
		begin_return_state()
	else:
		move_and_slide(vector * speed)
		if get_slide_count() > 0:
			begin_return_state()

func update_return_state() -> void:
	var trajectory = owner_node.global_position - global_position
	if abs(trajectory.length()) < 5:
		emit_signal("returned_to_owner")
	else:
		move_and_slide(trajectory.normalized() * speed)

func begin_return_state() -> void:
	state = BoomerangState.RETURNING
	collision_layer = 0
	collision_mask = 0

func parry() -> void:
	begin_return_state()

func _on_damaged_other(other : Hitbox) -> void:
	if state != BoomerangState.RETURNING:
		begin_return_state()
