extends SimpleWanderMonster

func _ready() -> void:
	set_interaction(CollisionType.PLAYER, Interactions.damage_other)
	set_interaction(CollisionType.SWORD, Interactions.damage)
	print(interactions._interaction_map)
	animation_player.play(default_animation)
	#Initialize the first direction
	change_direction()
	connect("entity_hit", self, "_on_entity_hit")
