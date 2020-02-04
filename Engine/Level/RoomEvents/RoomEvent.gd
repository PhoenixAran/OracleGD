class_name RoomEvent
#warning: does not use static typing for custom game types
#to avoid cyclical dependencies
#no way to achieve this system nicely without circular references 

const Direction = Enums.Direction

var active := false setget set_active, is_active

func set_active(value : bool) -> void:
	active = value

func is_active() -> bool:
	return active

func initialize(level) -> void:
	pass
	
func begin() -> void:
	pass

func update(delta : float) -> void:
	pass
	
func end() -> void:
	pass
