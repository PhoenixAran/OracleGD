extends Entity
class_name Monster

const EnemyState = Enums.EnemyState
onready var death_effect := preload("res://Scenes/Effects/DefaultDeath.tscn") as PackedScene

func destroy() -> void:
	var effect = death_effect.instance()
	effect.transform = global_transform
	get_parent().add_child(effect)
	queue_free()


