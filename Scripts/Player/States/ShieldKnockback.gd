extends State

var player : Entity
var shield : Shield
var shield_slot : ItemSlot

func initialize(context) -> void:
	player = context as Entity

func begin(args = null) -> void:
	player.anim_state = "shieldidle"
	player.update_animation()
	shield_slot = args as ItemSlot
	shield = shield_slot.get_item() as Shield

func update(delta : float) -> void:
	if not shield_slot.is_action_pressed():
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")

func end() -> void:
	shield = null
	shield_slot = null
