class_name DamageInteraction

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	var receiver_entity = receiver.get_parent()
	receiver_entity.take_damage(sender.get_damage_info())
	sender.notify_did_damage(receiver)
	
	