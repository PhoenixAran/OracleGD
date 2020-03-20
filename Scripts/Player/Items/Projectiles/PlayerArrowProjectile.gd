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
	move_and_slide(vector.normalized() * speed)
	if get_slide_count() > 0:
		begin_tumble_state()

func begin_tumble_state() -> void:
	arrow_state = ArrowState.TUMBLE
	collision_layer = 0
	collision_mask = 0
	match vector:
		Vector2.UP:
			anim_player.play("tumbleup")
		Vector2.DOWN:
			anim_player.play("tumbledown")
		Vector2.RIGHT:
			anim_player.play("tumbleright")
		Vector2.LEFT:
			anim_player.play("tumbleright")
	anim_player.connect("animation_finished", self, "_on_tumble_state_end")

func update_tumble_state(delta : float) -> void:
	pass

func _on_tumble_state_end(key) -> void:
	destroy()

func _on_damage_other(other : Hitbox) -> void:
	destroy()

func destroy() -> void:
	emit_signal("projectile_destroyed", self)
	queue_free()
