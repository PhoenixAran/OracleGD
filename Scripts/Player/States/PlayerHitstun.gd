#PlayerHitstun.gd
extends State

var player : CombatEntity
var movement_variables_reset := false
var item_slot_a : ItemSlot
var item_slot_b : ItemSlot

func initialize(context) -> void:
	player = context as CombatEntity

func begin(args = null) -> void:
	player.anim_state = "idle"
	movement_variables_reset = false
	item_slot_a = player.get("item_slot_a")
	item_slot_b = player.get("item_slot_b")

func update(delta : float) -> void:
	#Todo: Make a state called PlayerHurt so PlayerHitstun only has to worry about hitstun
	if not player.in_hitstun():
		if player.in_knockback():
			if item_slot_a.can_use() and item_slot_a.is_action_pressed():
				_change_state(item_slot_a.get_use_state("PlayerKnockback"), item_slot_a)
			elif item_slot_b.can_use() and  item_slot_b.is_action_pressed():
				_change_state(item_slot_b.get_use_state("PlayerKnockback"), item_slot_b)
			else:
				_change_state("PlayerKnockback")
		else:
			player.reset_movement_variables()
			if item_slot_a.can_use() and item_slot_a.is_action_pressed():
				_change_state(item_slot_a.get_use_state("PlayerIdle"), item_slot_a)
			elif item_slot_b.can_use() and item_slot_b.is_action_pressed():
				_change_state(item_slot_b.get_use_state("PlayerIdle"), item_slot_b)
			else:
				_change_state("PlayerIdle")
	elif not player.in_knockback() and not movement_variables_reset:
		player.reset_movement_variables()
		movement_variables_reset = true
		
func end() -> void:
	movement_variables_reset = false
