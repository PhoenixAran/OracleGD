extends Player

func _ready() -> void:
	set_interaction(CollisionType.MONSTER, Interactions.Damage)
