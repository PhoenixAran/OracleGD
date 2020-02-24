extends Interaction
class_name CustomInteraction

var _target : Node
var _function_name : String
var _override_parent := false setget set_override_parent, override_parent

func initialize(target, function_name : String) -> void:
	_target = target
	_function_name = function_name

func resolve(receiver : Hitbox, sender : Hitbox) -> void:
	assert(_target.has_method(_function_name))
	_target.call(_function_name, receiver, sender)

func set_override_parent(value : bool) -> void:
	_override_parent = true

func override_parent() -> bool:
	return _override_parent
