extends Monster
class_name SimpleWanderMonster

const directions := [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const animation_directions := ["up", "down", "left", "right"]

onready var hitbox := $Hitbox as Hitbox

export(bool) var has_animation_direction := false
export(int) var move_length := 30
export(String) var default_animation

var move_time := 0
var state = Enums.EnemyState.IDLE

func _physics_process(delta : float) -> void:
	update_ai()
	update_animation()
	update_movement()

func update_ai() -> void:
	match state:
		EnemyState.MOVE:
			move_time += 1
			if move_length <= move_time:
				change_direction()
		EnemyState.HURT:
			if not ( in_hitstun() and in_knockback() ):
				reset_movement_variables()
				state = EnemyState.MOVE

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
	state = EnemyState.HURT