extends Node2D
class_name Item

export(bool) var _can_use := true
export(bool) var _in_use := false
export(Enums.ItemMoveType) var move_type = Enums.ItemMoveType.NO_MOVE

func use_item():
	_in_use = true

func stop_use():
	_can_use = false

func _ready():
	pass
