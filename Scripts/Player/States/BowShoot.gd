#BowShoot
extends State

var player : CombatEntity
var bow_slot : ItemSlot
var bow_item : PlayerBow
var use_delay := 0
var delay_counter := 0

func initialize(context) -> void:
	player = context as CombatEntity

func begin(args = null) -> void:
	bow_slot = args as ItemSlot
	bow_item = bow_slot.get_item() as PlayerBow
	bow_slot.use_item(player.anim_direction)
	player.anim_state = "boomerangthrow"
	use_delay = bow_item.use_delay
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
