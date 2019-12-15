extends State
class_name SwordSwing

var player : Entity
var sword : PlayerItem

func initialize(context) -> void:
	player = context as Entity
	sword = player.get("sword")

func begin() -> void:
	player.anim_state = "attack"
	player.update_animation()
	sword.use_item(player.anim_direction)


func update(delta : float) -> void:
	if not sword.in_use():
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")
