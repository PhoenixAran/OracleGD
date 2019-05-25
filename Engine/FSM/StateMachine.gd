extends Node
class_name StateMachine

export(String) var _default_state
var _current_state
var _last_state

func _ready() -> void:
	var children := get_children()
	for child in children:
		child.connect("change_state", self, "_on_state_change")
		
func _physics_process(delta : float) -> void:
	_current_state.update(delta)		
		
func _on_state_change(state : String) -> void:
	if _current_state != null:
		_last_state.end()
	_last_state = _current_state
	_current_state = get_node(state)
	_current_state.begin()
	
