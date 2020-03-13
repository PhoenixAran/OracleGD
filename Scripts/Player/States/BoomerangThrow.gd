#BoomerangThrow.gd
extends State

var player : CombatEntity
var boomerang_slot : ItemSlot
var boomerang_item : PlayerBoomerang
var use_delay := 0
var delay_counter := 0

func initialize(context) -> void:
	player = context as CombatEntity

func begin(args = null) -> void:
	boomerang_slot = args as ItemSlot
	boomerang_item = boomerang_slot.get_item() as PlayerBoomerang
	boomerang_slot.use_item(player.anim_direction)
	player.anim_state = "boomerangthrow"
	use_delay = boomerang_item.use_delay
	delay_counter = 0
	player.update_animation()

func update(delta : float) -> void:
	var input_vector := InputHelper.poll_direction_input()
	player.match_animation_direction(input_vector)
	player.set_vector(input_vector)
	
	if delay_counter <= use_delay:
		delay_counter += 1
	else:
		_change_state("PlayerMove")


