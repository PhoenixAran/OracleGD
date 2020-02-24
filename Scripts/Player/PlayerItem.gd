extends Item
class_name PlayerItem

export(String) var use_state setget set_use_state, get_use_state
export(int) var item_level := 1 setget, get_item_level

func get_use_state() -> String:
	return use_state

func set_use_state(value : String) -> void:
	use_state = value

func get_item_level() -> int:
	return item_level
