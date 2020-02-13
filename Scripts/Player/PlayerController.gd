extends StateMachine
class_name PlayerController

#signal callbacks
func _on_entity_hit() -> void:
	change_state("PlayerHitstun")

func _on_entity_bump() -> void:
	change_state("PlayerKnockback")
