extends State
class_name PlayerHitstun

var player : Entity

func initialize(context) -> void:
	player = context as Entity
	
func begin() -> void:
	player.anim_state = "idle"

func update(delta : float) -> void:
	if not player.in_hitstun():
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")
	elif not player.in_knockback():
		player.reset_movement_variables()