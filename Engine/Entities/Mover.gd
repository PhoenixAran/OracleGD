extends Node
class_name Mover

#place this node at the bottom to cleanly updpate
#entity movement when the other nodes are done processing

onready var entity := get_parent() as Entity

func _physics_process(delta : float):
    entity.move(delta)
