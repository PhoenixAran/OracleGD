#ShieldKnockback.gd
extends State

var player : Entity
var shield : Shield
var shield_slot : ItemSlot
var other_slot : ItemSlot

func initialize(context) -> void:
	player = context as Entity

func begin(args = null) -> void:
	player.anim_state = "shieldidle"
	player.update_animation()
	shield_slot = args as ItemSlot
	shield = shield_slot.get_item() as Shield
	other_slot = player.get_other_item_slot(shield_slot)

func update(delta : float) -> void:
	if not shield_slot.is_action_pressed():
		if other_slot.is_action_pressed():
			_change_state(other_slot.get_use_state(name), other_slot)
		elif player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")

func end() -> void:
	shield = null
	shield_slot = null
