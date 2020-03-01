extends State

var player : Entity
var item_slot_a : ItemSlot
var item_slot_b : ItemSlot

func initialize(context) -> void:
	player = context as Entity
	player.current_speed = player.static_speed
	item_slot_a = player.get("item_slot_a")
	item_slot_b = player.get("item_slot_b")

func begin(args = null) -> void:
	player.reset_combat_variables()
	player.anim_state = "idle"
	player.set_vector(Vector2.ZERO)

func update(delta : float) -> void:
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	if Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	if Input.is_action_pressed("ui_right"):
		input_vector.x = 1

	player.match_animation_direction(input_vector)

	if item_slot_a.is_action_just_pressed() and item_slot_a.has_item():
		_change_state(item_slot_a.get_use_state(name), item_slot_a)
	elif item_slot_b.is_action_just_pressed() and item_slot_b.has_item():
		_change_state(item_slot_b.get_use_state(name), item_slot_b)
	elif input_vector != Vector2.ZERO:
		player.set_vector(input_vector)
		_change_state("PlayerMove")
