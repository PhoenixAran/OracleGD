extends Node
class_name StateMachine

export(String) var _default_state : String

var _current_state : State
var _last_state : State

func _ready() -> void:
	var children := get_children()
	for child in children:
		child.connect("state_changed", self, "change_state")
	_current_state = get_node(_default_state) as State

func initialize() -> void:
	var children = get_children()
	for child in children:
		(child as State).initialize()

func _physics_process(delta : float) -> void:
	_current_state.reason()
	#the update method is mandatory. no need to check for it
	_current_state.update(delta)

#acts as method and signal response
func change_state(state : String) -> void:
	if _current_state != null:
		_current_state.end()
	_last_state = _current_state
	_current_state = get_node(state)
	_current_state.begin()
