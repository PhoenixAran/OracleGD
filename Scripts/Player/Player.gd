extends Entity
class_name Player

onready var player_controller := $PlayerController as StateMachine
onready var hitbox := $Hitbox as Hitbox
onready var sprite := $EntitySprite as EntitySprite

func _ready() -> void:
	player_controller.initialize(self)
	health.connect("health_depleted", self, "_on_health_depleted")
	connect("entity_bumped", player_controller, "_on_entity_bumped")
	connect("entity_hit", player_controller, "_on_entity_hit")
	connect("entity_hit", sprite, "_on_entity_hit")

#Signal callbacks
func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	interactions.resolve_interaction(hitbox, other_hitbox)

