#ShieldKnockback.gd
extends State

var player : CombatEntity
var shield : Shield
var shield_slot : ItemSlot
var other_slot : ItemSlot
var other_slot_button_released := false

func initialize(context) -> void:
	player = context as CombatEntity

func begin(args = null) -> void:
	player.anim_state = "shieldidle"
	player.update_animation()
	shield_slot = args as ItemSlot
	shield = shield_slot.get_item() as Shield
	other_slot = player.get_other_item_slot(shield_slot)
	other_slot_button_released = not other_slot.is_action_pressed()

func update(delta : float) -> void:
	if not other_slot_button_released:
		other_slot_button_released = not other_slot.is_action_pressed()
	
	print(player.animation_player.current_animation)
	
	if player.in_knockback():
		if other_slot_button_released and other_slot.is_action_pressed():
			_change_state(other_slot.get_use_state(name), other_slot)
			shield_slot.stop_use()
		elif not shield_slot.is_action_pressed():
			_change_state("PlayerKnockback")
			shield_slot.stop_use()
	else:
		if other_slot_button_released and other_slot.is_action_pressed():
			_change_state(other_slot.get_use_state(name), other_slot)
			shield_slot.stop_use()
		elif shield_slot.is_action_pressed():
			_change_state("ShieldIdle", shield_slot)
		else:
			_change_state("PlayerIdle")
			shield_slot.stop_use()
			
func _change_state(state : String, args = null) -> void:
	print("Changing to " + state)
	._change_state(state, args)
