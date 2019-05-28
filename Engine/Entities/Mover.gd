extends Node
class_name Mover

onready var entity := get_parent() as Entity

func _physics_process(delta : float):
    entity.move(delta)
