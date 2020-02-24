extends PlayerItem
class_name PlayerSword

enum SwordState {
	CHARGING,
	CHARGED,
	OTHER
}

signal sword_swung
signal sword_loading
signal sword_stabbed
signal sword_spin(level)

export(int) var charge_frames := 5

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite
onready var hitbox := $Hitbox as Hitbox
onready var interactions := InteractionResolver.new()

var sword_state = SwordState.OTHER
var charge_frame_count := 0
var cached_direction := ""

func _physics_process(delta : float) -> void:
	if sword_state == SwordState.CHARGING:
		charge_frame_count += 1
		if charge_frame_count <= charge_frames:
			sword_state == SwordState.CHARGED
			charge_frame_count = 0
			animation_player.play(cached_direction + "charged")

func use_item(direction : String) -> void:
	var key := "attack" + direction
	cached_direction = direction
	animation_player.stop()
	animation_player.play(key)
	emit_signal("item_used")

func swing_sword(direction : String) -> void:
	use_item(direction)
	emit_signal("sword_swung")

func spin_attack(direction : String) -> void:
	if sword_state == SwordState.CHARGED:
		sword_state = SwordState.OTHER
		animation_player.play("spinattack" + direction)

func cancel_charge() -> void:
	charge_frame_count = 0
	sword_state = SwordState.OTHER
	animation_player.stop()

func charge_sword(direction : String) -> void:
	cached_direction = direction
	animation_player.play("charging" + direction)
	sword_state = SwordState.CHARGING

func spin_attack_ready() -> bool:
	return sword_state == SwordState.CHARGED

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
			animation_player.play()
	else:
		animation_player.stop(false)

func overrides_interaction(sender : Hitbox) -> bool:
	if hitbox.overlaps_area(sender):
		return interactions.has_interaction(sender.TYPE)
	return false

#Signal callbacks
func _on_owner_hit() -> void:
	stop_use()
