extends State

var player : Entity
var sword : PlayerItem
var attack_key_released : bool  = false
var sword_slot : ItemSlot

func initialize(context) -> void:
	player = context as Entity

func begin(args = null) -> void:
	player.anim_state = "attack"
	player.update_animation()
	sword_slot = args
	sword = args.get_item()
	sword.use_item(player.anim_direction)
	attack_key_released = not sword_slot.is_action_pressed()

func update(delta : float) -> void:
	if not attack_key_released:
		attack_key_released = not sword_slot.is_action_pressed()

	if sword.in_use():
		if attack_key_released and sword_slot.is_action_just_pressed():
			sword.use_item(player.anim_direction)
	else:
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")
