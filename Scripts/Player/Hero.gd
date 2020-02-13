extends Player
#Made this script so I can set interactions without having to deal with
#the huge player script file

func _ready() -> void:
	set_interaction(CollisionType.MONSTER, Interactions.Damage)
