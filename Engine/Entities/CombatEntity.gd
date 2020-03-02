extends Entity
class_name CombatEntity

#Signals
signal entity_hit
signal entity_bumped
signal entity_immobilized
signal entity_marked_dead(entity)

#Nodes / Resources
onready var hitbox := $Hitbox as Hitbox
onready var combat := Combat.new() as Combat
onready var health := $Health as Health
onready var interactions := InteractionResolver.new()
onready var ecb := $ECB as EnvironmentalCollisionBox

#Declarations
var _death_marked := false

#Godot API 
func _ready() -> void:
	health.connect("health_depleted", self, "_on_health_depleted")
	hitbox.connect("hitbox_entered", self, "_on_hitbox_entered")

#Methods
func die() -> void:
	collision_layer = 0
	emit_signal("entity_marked_dead", self)
	_death_marked = true

func destroy() -> void:
	emit_signal("entity_destroyed", self)
	queue_free()

func poll_death() -> void:
	if _death_marked and not in_hitstun() and not in_knockback():
		destroy()

func update_combat_variables() -> void:
	combat.update_combat_variables()

func get_health() -> int:
	return health.get_health()

func get_max_health() -> int:
	return health.get_max_health()

func is_dead() -> bool:
	return _death_marked

func is_intangible() -> bool:
	return combat.is_intangible()

func in_hitstun() -> bool:
	return combat.in_hitstun()

func in_knockback() -> bool:
	return combat.in_knockback()

func reset_combat_variables() -> void:
	combat.reset_combat_variables()

func set_vector_away(other_vector : Vector2) -> void:
	set_vector(global_position - other_vector)

func set_intangibility(frames : int, modulate_sprite = true) -> void:
	combat.set_intangibility(frames)
	if modulate_sprite:
		entity_sprite.set_modulate_time(frames)

func set_knockback(frames : int) -> void:
	combat.set_knockback(frames)

func set_hitstun(frames : int) -> void:
	combat.set_hitstun(frames) 

func set_combat_variables(damage_info : Dictionary) -> void:
	combat.set_combat_variables(damage_info)

func take_damage(value : int) -> void:
	health.take_damage(value)

func take_hit(damage_info : Dictionary) -> void:
	clear_counter_vector_and_speed()
	reset_combat_variables()
	set_intangibility(18)
	set_combat_variables(damage_info)
	take_damage(damage_info.damage)
	set_vector_away(damage_info.source_position)
	target_speed = damage_info.knockback_speed
	current_acceleration = 1.0
	current_deceleration = 1.0
	emit_signal("entity_hit")

func bump(speed : float, direction : Vector2, time : int) -> void:
	set_intangibility(8, false)
	clear_counter_vector_and_speed()
	reset_combat_variables()
	combat.knockback_time = time
	combat.current_knockback_speed = speed
	vector = direction
	current_acceleration = 1.0
	current_deceleration = 1.0
	emit_signal("entity_bumped")

func immobilize(time : int) -> void:
	combat.current_hitstun_time = time
	emit_signal("entity_immobilized")

func on_platform() -> bool:
	return ecb.current_platform != null

#entity / hitbox interactions
func set_interaction(type, interaction : Interaction) -> void:
	interactions.set_interaction(type, interaction)

func get_interaction(type) -> Interaction:
	return interactions.get_interaction(type)

func remove_interaction(type) -> void:
	interactions.remove_interaction(type)

func has_interaction(type) -> bool:
	return interactions.has_interaction(type)

func resolve_interaction(receiver : Hitbox, sender : Hitbox) -> void:
	interactions.resolve_interaction(receiver, sender)

func get_interaction_resolver() -> InteractionResolver:
	return interactions

#this method is used when the entity is not configured to automatically respond to
#a given hitbox type. This allows the entity to check if any of it's items can
#protect it from the sender. This is usually just used on the player since players
#are not automatically set to collide with monsters, but they should still be able to block
#attacks with a shield or parry attacks with a sword
func trigger_override_interactions(sender : Hitbox) -> bool:
	return false

#tile interactions
func set_tile_interaction(type, interaction) -> void:
	interactions.set_tile_interaction(type, interaction)

func get_tile_interaction(type):
	return interactions.get_tile_interaction(type)

func remove_tile_interaction(type):
	interactions.remove_interaction(type)
	
func has_tile_interaction(type) -> bool:
	return interactions.has_interaction(type)

#signal callback responses
func _on_health_depleted(damage : int) -> void:
	die()

func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	interactions.resolve_interaction(hitbox, other_hitbox)

func _on_dynamic_tile_entered(tile) -> void:
	interactions.resolve_tile_interaction(ecb, tile)

func _on_platform_entered(platform : MovingPlatform) -> void:
	platform.register_rider(self)

func _on_platform_exited(platform : MovingPlatform) -> void:
	platform.unregister_rider(self)
