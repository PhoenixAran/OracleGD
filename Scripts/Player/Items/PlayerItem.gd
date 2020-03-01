extends Item
class_name PlayerItem

export(String) var use_state setget set_use_state, get_use_state
export(int) var item_level := 1 setget, get_item_level
export(Dictionary) var condition_states := { }

func get_use_state(current_state = null) -> String:
	if current_state == null or not condition_states.has(current_state):
		return use_state
	return condition_states[current_state]
func set_use_state(value : String) -> void:
	use_state = value

func get_item_level() -> int:
	return item_level
