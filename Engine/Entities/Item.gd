extends Node2D
class_name Item

signal item_used

export(bool) var _can_use := true setget, can_use
export(bool) var _in_use := false setget, in_use
export(Enums.ItemMoveType) var move_type = Enums.ItemMoveType.NO_MOVE

func use_item(direction : String) -> void:
	_in_use = true

func stop_use() -> void:
	_can_use = false

func can_use() -> bool: 
	return _can_use

func in_use() -> bool:
	return _in_use

func enable(enabled : bool) -> void:
	pass

func overrides_interaction(sender : Hitbox) -> bool:
	return false
