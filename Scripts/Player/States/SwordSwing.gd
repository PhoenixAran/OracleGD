extends State
class_name SwordSwing

var player : Entity
var sword : PlayerItem
var attack_key_released : bool = false

func initialize(context) -> void:
	player = context as Entity
	sword = player.get("sword")

func begin() -> void:
	player.anim_state = "attack"
	player.update_animation()
	sword.use_item(player.anim_direction)
	attack_key_released = not Input.is_action_pressed("attack")

func update(delta : float) -> void:
	if not attack_key_released:
		attack_key_released = not Input.is_action_pressed("attack")

	if sword.in_use():
		if attack_key_released and Input.is_action_just_pressed("attack"):
			sword.use_item(player.anim_direction)
	else:
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")
