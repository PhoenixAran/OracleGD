extends PlayerItem
class_name Shield

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

func overrides_interaction(sender : Hitbox) -> bool:
	if not hitbox.overlaps_area(sender):
		return false
	var parent = sender.get_parent()
	if parent and parent.has("interactions"):
		var interaction_resolver = parent.get("interactions")
		if interaction_resolver.has_interaction(Enums.CollisionType.SHIELD):
			var shield_interaction = interaction_resolver.get_interaction(Enums.CollisionType.SHIELD)
			if shield_interaction is IgnoreInteraction:
				return false
			elif shield_interaction.has_method("override_parent") and shield_interaction.call("override_parent"):
				return false
			return true
	return false
