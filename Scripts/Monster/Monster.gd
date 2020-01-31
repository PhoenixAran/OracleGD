extends CombatEntity
class_name Monster

const EnemyState = Enums.EnemyState
onready var death_effect := preload("res://Scenes/Effects/DefaultDeath.tscn") as PackedScene

func _physics_process(delta : float) -> void:
	poll_death()
	update_combat_variables()
	update_ai(delta)
	update_animation()
	update_movement(delta)

func update_ai(delta : float) -> void:
	pass

func destroy() -> void:
	var effect = death_effect.instance()
	effect.transform = global_transform
	get_parent().add_child(effect)
	emit_signal("entity_destroyed", self)
	queue_free()


