extends PlayerItem
class_name Shield

signal bump_reaction(speed, direction, duration)

onready var hitbox := $Hitbox as Hitbox
onready var anim_player := $AnimationPlayer as AnimationPlayer

var cached_direction : String

func use_item(direction : String) -> void:
	_in_use = true
	cached_direction = direction
	anim_player.play(direction)

func update_direction(direction : String) -> void:
	if direction != cached_direction:
		cached_direction = direction
		anim_player.play(direction)

func stop_use() -> void:
	_in_use = false
	hitbox.enable_area(false)
	anim_player.stop()

func enable(enabled : bool) -> void:
	set_physics_process(enabled)
	hitbox.set_physics_process(enabled)

func notify_bump_reaction(speed : float, direction : Vector2, duration : int) -> void:
	emit_signal("bump_reaction", speed, direction, duration)

func overrides_interaction(sender : Hitbox) -> bool:
	if sender.TYPE != Enums.CollisionType.MONSTER or in_use():
		return false
	if not hitbox.overlaps_area(sender):
		return false
	var parent = sender.get_parent()
	if parent and parent.has_method("get_interaction_resolver"):
		var interaction_resolver = parent.call("get_interaction_resolver")
		if interaction_resolver.has_interaction(Enums.CollisionType.SHIELD):
			var shield_interaction = interaction_resolver.get_interaction(hitbox.TYPE)
			if shield_interaction is IgnoreInteraction:
				return false
			elif shield_interaction.has_method("override_parent") and shield_interaction.call("override_parent"):
				return false
			return true
	return false

