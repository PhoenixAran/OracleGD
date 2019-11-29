extends State
class_name PlayerKnockback

var player : Entity

func initialize(context) -> void:
	player = context as Entity
	
func begin() -> void:
	player.anim_state = "idle"
	
func update(delta : float) -> void:
	if not player.in_knockback():
		player.reset_movement_variables()
		_change_state("PlayerIdle")
	elif not player.in_hitstun():
		#player can use their item mid knockback
		if Input.IsActionJustPressed("attack"):
			_change_state("PlayerAttack")
