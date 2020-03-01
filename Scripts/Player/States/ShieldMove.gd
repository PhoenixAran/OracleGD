#ShieldMove.gd
extends State

var player : Entity
var shield : Shield
var shield_slot : ItemSlot
var other_slot : ItemSlot
var other_slot_button_released := false

func initialize(context) -> void:
	player = context as Entity

func begin(args = null) -> void:
	player.anim_state = "shieldmove"
	player.update_animation()
	shield_slot = args as ItemSlot
	shield = shield_slot.get_item() as Shield
	other_slot = player.get_other_item_slot(shield_slot)
	
	other_slot_button_released = not other_slot.is_action_pressed()

func update(delta : float) -> void:
	if not other_slot_button_released:
		other_slot_button_released = not other_slot.is_action_pressed()
	
	var input_vector := Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	player.match_animation_direction(input_vector)
	player.set_vector(input_vector)
	
	if other_slot_button_released and other_slot.is_action_pressed():
		_change_state(other_slot.get_use_state(name), other_slot)
	elif not shield_slot.is_action_pressed():
		if input_vector == Vector2.ZERO:
			_change_state("PlayerIdle")
		else:
			_change_state("PlayerMove")
	elif input_vector == Vector2.ZERO:
		_change_state("ShieldIdle", shield_slot)


func end() -> void:
	shield_slot.stop_use()
