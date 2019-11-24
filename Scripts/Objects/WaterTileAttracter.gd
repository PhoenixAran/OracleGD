##Hitboxes to surround watertiles boundaries
##that will push entities towards water if they stand near watertiles

extends Area2D
class_name TileAttracter

export(Enums.Direction) var direction = Enums.Direction.DOWN

func _ready() -> void:
	pass
