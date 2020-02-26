extends Interaction
class_name ShieldBump

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	var receiver_entity = receiver.get_parent()
	var sender_entity = sender.get_parent()
	receiver_entity.bump(55, sender_entity.position - receiver_entity.position)
	sender_entity.notify_bump_reaction(55, receiver_entity.position - sender_entity.position)
