extends Interaction
class_name ShieldBump

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	var receiver_entity = receiver.get_parent()
	var sender_entity = sender.get_parent()
	var sender_entity_owner = sender_entity.get_parent().get_parent()
	if not sender_entity_owner.in_hitstun():
		receiver_entity.bump(65, sender_entity.position - receiver_entity.position, 30)
		sender_entity.notify_bump_reaction(65, receiver_entity.position - sender_entity.position, 30)
