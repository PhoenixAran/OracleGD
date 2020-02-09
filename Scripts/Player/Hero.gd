extends Player

#Use this script to set interactions so you don't need to touch the Player.gd
#file

#Set interactions here
func _ready() -> void:
	set_interaction(CollisionType.MONSTER, Interactions.Damage)
