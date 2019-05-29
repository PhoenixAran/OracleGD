class_name DamageInteraction

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	receiver.call("take_damage", sender)
	sender.notify_did_damage(receiver)
	