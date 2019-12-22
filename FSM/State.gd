extends Node
class_name State

signal state_changed(state, args)

func initialize(context) -> void:
	pass

func reason() -> void:
	pass

func begin(args = null) -> void:
	pass

func update(delta : float) -> void:
	pass

func end() -> void:
	pass

func _change_state(state : String, args = null) -> void:
	emit_signal("state_changed", state, args)
