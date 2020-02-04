extends Interaction
class_name DamageInteraction

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	var receiver_entity = receiver.get_parent()
	if not receiver_entity.is_intangible():
		receiver_entity.reset_combat_variables()
		receiver_entity.take_hit(sender.get_damage_info())
		sender.notify_did_damage(receiver)
