extends Node
class_name StateMachine

signal on_initialized(state_machine)

export(String) var _default_state
var _current_state
var _last_state

func _ready() -> void:
	var children := get_children()
	for child in children:
		child.connect("state_changed", self, "change_state")

func _initialize() -> void:
	for child in children:
		if child.has_method("initialize"):
			child.initialize()

func _physics_process(delta : float) -> void:
	if _current_state.has_method("reason"):
		_current_state.reason()
	#the update method is mandatory. no need to check for it
	_current_state.update(delta)

func change_state(state : String) -> void:
	if _current_state != null && _last_state.has_method("end"):
		_last_state.end()
	_last_state = _current_state
	_current_state = get_node(state)
	if _current_state.has_method("begin"):
		_current_state.begin()
