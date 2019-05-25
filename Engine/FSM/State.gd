extends Node
class_name State

signal state_changed(state)

func change_state(state : String) -> void:
    emit_signal("state_changed", state)
