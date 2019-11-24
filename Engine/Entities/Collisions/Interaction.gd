class_name Interaction

#faux interface for interactions to use
#Until Godot fixes cyclic dependency scripts don't type Entity variables
func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	pass
