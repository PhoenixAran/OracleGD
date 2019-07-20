extends Item
class_name PlayerSword

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite
onready var hitbox := $Hitbox as Hitbox
onready var interactions := InteractionResolver.new()

var _attack_key_released := false
var _cached_direction := "down"

func _physics_process(delta : float) -> void:
	if not in_use():
		return
	if not _attack_key_released:
		_attack_key_released = not Input.is_action_pressed("attack")
	elif Input.is_action_just_pressed("attack"):
		use_item(_cached_direction)

func use_item(direction : String) -> void:
	_cached_direction = direction
	_attack_key_released = not Input.is_action_pressed("attack")
	var key := "attack" + _cached_direction
	animation_player.stop()
	animation_player.play(key)
	emit_signal("item_used")

func stop_use() -> void:
	animation_player.stop()
	_in_use = false
	if sprite.is_visible():
    	sprite.set_visible(false)
	hitbox.enable_area(false)

func enable(enabled : bool) -> void:
	set_physics_process(enabled)
	hitbox.set_physics_process(enabled)
	if enabled:
		if _in_use:
			animation_player.play(animation_player.current_animation)
	else:
		animation_player.stop(false)

func overrides_interaction(sender : Hitbox) -> bool:
	if hitbox.overlaps_area(sender):		
		return interactions.has_interaction(sender.TYPE)
	return false

#Signal callbacks
func _on_owner_hit() -> void:
	stop_use()
