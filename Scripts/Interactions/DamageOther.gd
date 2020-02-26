extends Interaction
class_name DamageOtherInteraction

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	var target_entity = sender.get_parent()
	if not target_entity.trigger_override_interactions(receiver):
		if not target_entity.is_intangible():
			target_entity.reset_combat_variables()
			target_entity.take_hit(receiver.get_damage_info())
			receiver.notify_did_damage(sender)
