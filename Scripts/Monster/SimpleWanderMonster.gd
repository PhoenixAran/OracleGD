extends Monster
class_name SimpleWanderMonster

const directions := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const animation_directions := ["up", "down", "left", "right"]

export(bool) var has_animation_direction := false
export(int) var move_length := 30
export(String) var default_animation

var move_time := 0
var state = Enums.EnemyState.MOVING

#override
func update_animation(force_update := false) -> void:
	if not animation_player.is_playing():
		var key := anim_direction + anim_state if has_animation_direction else "move"
		if state == EnemyState.MOVING:
			animation_player.play(key)

func update_ai() -> void:
	match state:
		EnemyState.MOVING:
			move_time += 1
			if move_length <= move_time:
				change_direction()
		EnemyState.HURT:
			if not ( in_hitstun() and in_knockback() ):
				if in_hitstun():
					state = EnemyState.IN_HITSTUN
				elif in_knockback():
					state = EnemyState.IN_KNOCKBACK
				else:
					state = EnemyState.MOVING
					prep_for_move_state()
		EnemyState.IN_HITSTUN:
			if not in_hitstun():
				state = EnemyState.MOVING
				prep_for_move_state()
		EnemyState.IN_KNOCKBACK:
			if not in_knockback():
				state = EnemyState.MOVING
				prep_for_move_state()
		EnemyState.DEAD:
			pass

func prep_for_move_state() -> void:
	reset_combat_variables()
	reset_movement_variables()
	change_direction()

func enabled(enabled : bool) -> void:
	set_physics_process(enabled)
	hitbox.set_physics_process(enabled)
	if enabled:
		animation_player.play(animation_player.current_animation)
	else:
		animation_player.stop()

#randomly changes direction
func change_direction() -> void:
	move_time = 0
	var index := randi() % directions.size()
	vector = directions[index]
	if has_animation_direction:
		anim_direction = animation_directions[index]

#signal callbacks
func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	interactions.resolve_interaction(hitbox, other_hitbox)
	
func _on_entity_hit() -> void:
	animation_player.stop()
	if in_hitstun() and in_knockback():
		state = EnemyState.HURT
	elif in_hitstun():
		state = EnemyState.IN_HITSTUN
	elif in_knockback():
		state = EnemyState.IN_KNOCKBACK

#Override
func _on_health_depleted(damage : int) -> void:
	._on_health_depleted(damage)
	state = EnemyState.DEAD