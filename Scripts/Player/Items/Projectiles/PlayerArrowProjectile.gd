#PlayerArrowProjectile.gd
extends KinematicBody2D

signal projectile_destroyed(projectile)

export(float) var speed := 112

enum ArrowState {
	MOVING,
	TUMBLE
}

onready var anim_player := $AnimationPlayer as AnimationPlayer
onready var hitbox := $Hitbox as Hitbox
onready var interactions := InteractionResolver.new() as InteractionResolver
onready var arrow_state = ArrowState.MOVING

var vector := Vector2()
var points := { }

func _ready() -> void:
	hitbox.connect("damaged_other", self, "_on_damage_other")

func shoot(input_vector : Vector2) -> void:
	match input_vector:
		Vector2.UP:
			anim_player.play("up")
		Vector2.DOWN:
			anim_player.play("down")
		Vector2.LEFT:
			anim_player.play("left")
		Vector2.RIGHT:
			anim_player.play("right")
	vector = input_vector

func _physics_process(delta : float) -> void:
	match arrow_state:
		ArrowState.MOVING:
			update_move_state(delta)
		ArrowState.TUMBLE:
			update_tumble_state(delta)

func update_move_state(delta : float) -> void:
	if move_and_slide(vector.normalized() * speed):
		begin_tumble_state()

func begin_tumble_state() -> void:
	arrow_state = ArrowState.TUMBLE
	collision_layer = 0
	collision_mask = 0
	match vector:
		Vector2.UP:
			
			pass
#			points["p0"] = global_position
#			points["p1"] = global_position + Vector2(0, 10)
#			points["p2"] = global_position + Vector2(0, -16) 
		Vector2.DOWN:
			pass
#			points["p0"] = global_position
#			points["p1"] = global_position + Vector2(0, -10)
#			points["p2"] = global_position + Vector2(0, 16) 
		Vector2.RIGHT:
			pass
#			points["p0"] = global_position
#			points["p1"] = global_position + Vector2(-6, 10)
#			points["p2"] = global_position + Vector2(-12, -2) 
		Vector2.LEFT:
			pass
#			points["p0"] = global_position
#			points["p1"] = global_position + Vector2(6, 10)
#			points["p2"] = global_position + Vector2(12, -2) 

func update_tumble_state(delta : float) -> void:
	var new_position := quadratic_bezier(points["p0"], points["p1"], points["p2"], 1)
	global_position = new_position
	if new_position == points["p2"]:
		emit_signal("projectile_destroyed", self)
		queue_free()
	
func quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func _on_damage_other(other) -> void:
	emit_signal("projectile_destroyed", self)
	queue_free()
