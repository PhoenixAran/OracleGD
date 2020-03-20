#PlayerIdle.gd
extends State

var player : CombatEntity
var item_slot_a : ItemSlot
var item_slot_b : ItemSlot

func initialize(context) -> void:
	player = context as CombatEntity
	player.current_speed = player.static_speed
	item_slot_a = player.get("item_slot_a")
	item_slot_b = player.get("item_slot_b")

func begin(args = null) -> void:
	player.reset_combat_variables()
	player.anim_state = "idle"
	player.set_vector(Vector2.ZERO)

func update(delta : float) -> void:
	var input_vector = InputHelper.poll_direction_input()

	player.match_animation_direction(input_vector)

	if item_slot_a.can_use() and item_slot_a.is_action_just_pressed():
		_change_state(item_slot_a.get_use_state(name), item_slot_a)
	elif item_slot_b.can_use() and item_slot_b.is_action_just_pressed():
		_change_state(item_slot_b.get_use_state(name), item_slot_b)
	elif input_vector != Vector2.ZERO:
		player.set_vector(input_vector)
		_change_state("PlayerMove")
