extends Entity
class_name Player

onready var player_controller := $PlayerController as StateMachine
onready var hitbox := $Hitbox as Hitbox
onready var sprite := $EntitySprite as EntitySprite
onready var item := $Item as Item

#Godot API 
func _ready() -> void:
	player_controller.initialize(self)
	_set_up_interactions()
	reset_movement_variables()
	health.connect("health_depleted", self, "_on_health_depleted")
	item.connect("item_used", self, "_on_item_used")
	hitbox.connect("hitbox_entered", self, "_on_hitbox_entered")
	
	connect("entity_bumped", player_controller, "_on_entity_bumped")
	connect("entity_hit", player_controller, "_on_entity_hit")
	connect("entity_hit", sprite, "_on_entity_hit")
	connect("entity_hit", item, "_on_entity_hit")

func _physics_process(delta : float) -> void:
	combat.update_combat_variables()
	player_controller.update(delta)
	update_animation()
	update_movement()

#Player methods
func _set_up_interactions() -> void:
	interactions.set_interaction(CollisionType.MONSTER, Interactions.Damage)

#Signal callbacks
func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	interactions.resolve_interaction(hitbox, other_hitbox)

func _on_item_used() -> void:
	animation_player.stop()