extends Node
class_name State

signal state_changed(state)

func reason() -> void:
    pass

func begin() -> void:
    pass

func update(float : delta) -> void:
    pass

func end() -> void:
    pass

func _change_state(state : String) -> void:
    emit_signal("state_changed", state)
