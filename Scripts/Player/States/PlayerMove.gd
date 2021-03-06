#PlayerMove.gd
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
	player.anim_state = "move"

func update(delta : float):
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
	if input_vector == Vector2.ZERO:
		_change_state("PlayerIdle")
	elif item_slot_a.is_action_just_pressed():
		player.set_vector(Vector2.ZERO)
		_change_state(item_slot_a.get_use_state(name), item_slot_a)
	elif item_slot_b.is_action_just_pressed() and item_slot_b.has_item():
		player.set_vector(Vector2.ZERO)
		_change_state(item_slot_b.get_use_state(name), item_slot_b)
	else:
		player.set_vector(input_vector)
