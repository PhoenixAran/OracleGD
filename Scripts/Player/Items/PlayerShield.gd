extends PlayerItem
class_name Shield

onready var hitbox := $Hitbox as Hitbox
onready var anim_player := $AnimationPlayer as AnimationPlayer
onready var sprite := $Sprite as Sprite

func use_item(direction : String) -> void:
	_in_use = true
	var key = "shield" + direction
	anim_player.play(key)

func stop_use() -> void:
	_in_use = false
	hitbox.enable(false)
	anim_player.stop()
	sprite.set_visible(false)

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
