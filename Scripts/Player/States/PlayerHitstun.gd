extends State
class_name PlayerHitstun

var player : Entity
var movement_variables_reset := false

func initialize(context) -> void:
	player = context as Entity
	
func begin() -> void:
	player.anim_state = "idle"
	movement_variables_reset = false

func update(delta : float) -> void:
	if not player.in_hitstun():
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")
	elif not player.in_knockback() and not movement_variables_reset:
		player.reset_movement_variables()
		movement_variables_reset = true
		
func end() -> void:
	movement_variables_reset = false