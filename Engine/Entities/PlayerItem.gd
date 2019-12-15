extends Item
class_name PlayerItem

export(String) var use_state setget set_use_state, get_use_state

func get_use_state() -> String:
	return use_state

func set_use_state(value : String) -> void:
	use_state = value
