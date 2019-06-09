extends Item
class_name PlayerSword

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite
onready var hitbox := $Hitbox as Hitbox

var _attack_key_released := false
var _cached_direction := "down"

func _physics_process(delta : float) -> void:
	if !in_use():
		return
	if !_attack_key_released:
		_attack_key_released = !Input.is_action_pressed("attack")
	elif Input.is_action_just_pressed("attack"):
		use_item(_cached_direction)

func use_item(direction : String) -> void:
	_cached_direction = direction
	_attack_key_released = !Input.is_action_pressed("attack")
	var key := "attack" + _cached_direction
	animation_player.stop()
	animation_player.play(key)
	emit_signal("item_used")

func stop_use() -> void:
	animation_player.stop()
	if sprite.is_visible():
    	sprite.set_visible(false)
	hitbox.set_enabled(false)

func _on_owner_hurt() -> void:
	stop_use()
