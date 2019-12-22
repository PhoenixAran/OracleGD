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


#context is dynamic so state machines can be used on anything
func initialize(context) -> void:
	var children = get_children()
	for child in children:
		assert(child is State)
		(child as State).initialize(context)

func update(delta : float) -> void:
	_current_state.reason()
	#the update method is mandatory. no need to check for it
	_current_state.update(delta)

#acts as method and signal response
func change_state(state : String, args = null) -> void:
	if _current_state != null:
		_current_state.end()
	_last_state = _current_state
	_current_state = get_node(state)
	_current_state.begin(args)

func current_state() -> String:
	return _current_state.name

func last_state() -> String:
	return _last_state.name
