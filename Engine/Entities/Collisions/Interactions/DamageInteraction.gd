class_name DamageInteraction

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	var receiver_entity := receiver.get_parent() as Entity
	receiver_entity.take_damage(sender.damage)
	sender.notify_did_damage(receiver)
	
	