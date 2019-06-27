extends SimpleWanderMonster
class_name Stalfos

func _ready() -> void:
	interactions.set_interaction(CollisionType.SWORD, Interactions.Damage)
	health.connect("health_depleted", self, "_on_health_depleted")
	hitbox.connect("hitbox_entered", self, "_on_hitbox_entered")
	animation_player.play(default_animation)
	#Initialize the first direction
	change_direction()
	connect("entity_hit", self, "_on_entity_hit")