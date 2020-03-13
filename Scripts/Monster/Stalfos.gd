extends SimpleWanderMonster

func _ready() -> void:
	set_interaction(CollisionType.BOOMERANG, Interactions.damage)
	set_interaction(CollisionType.PLAYER, Interactions.damage_other)
	set_interaction(CollisionType.SWORD, Interactions.damage)
	set_interaction(CollisionType.SHIELD, Interactions.shield_bump)
	animation_player.play(default_animation)
	#Initialize the first direction
	change_direction()
	connect("entity_hit", self, "_on_entity_hit")
	connect("entity_bumped", self, "_on_entity_bumped")
