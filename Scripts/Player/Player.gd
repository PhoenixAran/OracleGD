extends Entity
class_name Player

onready var player_controller := $PlayerController as StateMachine
onready var hitbox := $Hitbox as Hitbox

func _ready() -> void:
	health.connect("health_depleted", self, "_on_health_depleted")
	connect("entity_hit", self, "_on_entity_hit")
	#getting bumped is pretty much just a hit without damage or hitstun
	connect("entity_bumped", self, "_on_entity_hit")
	#getting immobolized is just getting hit without knockback or damage
	connect("entity_immobilized", self, "_on_entity_hit")
	player_controller.initialize()
	
#Signal callbacks
func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	interactions.resolve_interaction(hitbox, other_hitbox)
	
func _on_entity_hit() -> void:
	player_controller.change_state("PlayerHit")
	
