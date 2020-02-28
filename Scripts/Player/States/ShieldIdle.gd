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

func reason() -> void:
	if player.in_knockback():
		_change_state("ShieldKnockback", shield_slot)

func update(delta : float) -> void:
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
	if not shield_slot.is_action_pressed():
		if input_vector == Vector2.ZERO:
			_change_state("PlayerIdle")
		else:
			_change_state("PlayerMove")
	elif input_vector != Vector2.ZERO:
		_change_state("ShieldMove")

func end() -> void:
	shield_slot.stop_use()
	shield_slot = null
	shield = null

