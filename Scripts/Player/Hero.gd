#Hero.gd
extends Player
#Made this script so I can set interactions without having to deal with
#the huge player script file

func _ready() -> void:
	#Don't automatically set player to take damage from Monsters, let monsters decide 
	#how to deal with interactions
	#monsters like Gels and Floormasters won't damage the player and will have a custom interaction
	set_interaction(CollisionType.BOMB_EXPLOSION, Interactions.damage)
	#item_slot_a.get_item().connect("bump_reaction", self, "_on_shield_bump_reaction")
