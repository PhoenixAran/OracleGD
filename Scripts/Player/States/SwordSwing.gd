#SwordSwing.gd
extends State

var player : Entity
var sword : PlayerItem
var attack_key_released : bool  = false
var sword_slot : ItemSlot
var other_slot : ItemSlot

func initialize(context) -> void:
	player = context as CombatEntity

func begin(args = null) -> void:
	if not player.in_knockback():
		player.set_vector(Vector2())
	player.anim_state = "attack"
	player.update_animation()
	sword_slot = args
	sword = sword_slot.get_item()
	sword.swing_sword(player.anim_direction)
	attack_key_released = not sword_slot.is_action_pressed()
	other_slot = player.get_other_item_slot(sword_slot)

func update(delta : float) -> void:
	if not attack_key_released:
		attack_key_released = not sword_slot.is_action_pressed()

	if not player.in_knockback() and player.get_vector() != Vector2():
		player.set_vector(Vector2())

	if sword.in_use():
		if attack_key_released and sword_slot.is_action_just_pressed():
			sword.swing_sword(player.anim_direction)
	else:
		if other_slot.can_use() and other_slot.is_action_pressed():
			_change_state(other_slot.get_use_state(name), other_slot)
		elif player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")

