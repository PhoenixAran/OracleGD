extends State
class_name PlayerKnockback

var player : Entity

func initialize(context) -> void:
	player = context as Entity
	
func begin() -> void:
	player.anim_state = "idle"
	
func update(delta : float) -> void:
	if !player.in_knockback():
		_change_state("PlayerIdle")
	elif !player.in_hitstun():
		#player can use their item mid knockback
		if Input.IsActionJustPressed("attack"):
			_change_state("PlayerAttack")