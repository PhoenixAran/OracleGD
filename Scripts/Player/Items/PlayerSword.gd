extends PlayerItem
class_name PlayerSword

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite
onready var hitbox := $Hitbox as Hitbox
onready var interactions := InteractionResolver.new()

func use_item(direction : String) -> void:
	var key := "attack" + direction
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
		if in_use():
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
