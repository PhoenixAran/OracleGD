#PlayerKnockback.gd
extends State

var player : Entity
var item_slot_a : ItemSlot
var item_slot_b : ItemSlot

func initialize(context) -> void:
	player = context as Entity
	item_slot_a = player.get("item_slot_a")
	item_slot_b = player.get("item_slot_b")
	
func begin(args = null) -> void:
	player.anim_state = "idle"
	
func update(delta : float) -> void:
	if not player.in_knockback():
		player.reset_movement_variables()
		_change_state("PlayerIdle")
	elif not player.in_hitstun():
		#player can use their item mid knockback
		if item_slot_a.is_action_just_pressed():
			_change_state(item_slot_a.get_item_use_state(), item_slot_a)
		elif item_slot_b.is_action_just_pressed():
			_change_state(item_slot_b.get_item_use_state(), item_slot_b)
