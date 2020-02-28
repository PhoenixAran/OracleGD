extends StateMachine

#signal callbacks
func _on_entity_hit() -> void:
	change_state("PlayerHitstun")

func _on_entity_bump() -> void:
	if get_current_state() == "ShieldIdle" or get_current_state() == "ShieldMove":
		change_state("ShieldKnockback", _current_state.get("shield_slot"))
	else:
		change_state("PlayerKnockback")
