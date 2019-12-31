extends Entity
class_name CombatEntity

#Signals
signal entity_hit(damage)
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
	return combat.in_hitstun()

func reset_combat_variables() -> void:
	combat.reset_combat_variables()

func set_vector_away(other_vector : Vector2) -> void:
	set_vector(global_position - other_vector)

func set_intangibility(frames : int) -> void:
	combat.set_intangibility(frames)
	entity_sprite.set_modulate_time(frames)

func take_damage(damage_info : Dictionary) -> void:
	set_intangibility(18)
	combat.set_combat_variables(damage_info)
	health.take_damage(damage_info.damage)
	set_vector_away(damage_info.source_position)
	speed = damage_info.knockback_speed
	acceleration = 1.0
	deceleration = 1.0
	emit_signal("entity_hit", damage_info.damage)

func bump(speed : float, direction : Vector2, time : int) -> void:
	combat.knockback_time = time
	combat.current_knockback_speed = speed
	vector = direction
	acceleration = 1.0
	deceleration = 1.0
	emit_signal("entity_bumped")

func immobilize(time : int) -> void:
	combat.current_hitstun_time = time
	emit_signal("entity_immobilized")

func on_platform() -> bool:
	return ecb.current_platform != null

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
