class_name RoomEvent
#warning: does not use static typing for custom game types
#to avoid cyclical dependencies
#no way to achieve this system nicely without circular references 

const Direction = Enums.Direction

var is_active := false

func initialize(level) -> void:
	pass
	
func begin() -> void:
	pass

func update(delta : float) -> void:
	pass
	
func end() -> void:
	pass
