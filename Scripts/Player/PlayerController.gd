extends StateMachine

#signal callbacks
func _on_entity_hit() -> void:
	change_state("PlayerHitstun")

func _on_entity_bumped() -> void:
	if get_current_state() == "PlayerKnockback" or get_current_state() == "ShieldKnockback":
		return
	
	if get_current_state() == "ShieldIdle" or get_current_state() == "ShieldMove":
		change_state("ShieldKnockback", _current_state.get("shield_slot"))
	else:
		change_state("PlayerKnockback")
#
#func change_state(state : String, args = null) -> void:
#	print(get_current_state() + " transitioning to " + state)
#	.change_state(state, args)
