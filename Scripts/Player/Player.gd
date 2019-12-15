extends CombatEntity
class_name Player

const animation_states_with_shield := ["idle", "move"]

signal item_changed(item)
signal sword_changed(sword)

#Nodes / Resources
onready var player_controller := $PlayerController as StateMachine
onready var sprite := $EntitySprite as EntitySprite
onready var sword := get_node_or_null("Sword") as PlayerItem
onready var tween := $Tween as Tween
onready var equipment := $Equipment as Equipment

#Declarations
var in_transition := false

#Godot API 
func _ready() -> void:
	reset_movement_variables()
	player_controller.initialize(self)

	interactions.set_interaction(CollisionType.MONSTER, Interactions.Damage)
	
	connect("entity_bumped", player_controller, "_on_entity_bumped")
	connect("entity_hit", player_controller, "_on_entity_hit")
	connect("entity_hit", sword, "_on_owner_hit")
	
	sword.connect("item_used", self, "_on_item_used")
	tween.connect("tween_completed", self, "_on_tween_completed")
	
	ecb.connect("platform_entered", self, "_on_platform_entered")
	ecb.connect("platform_exited", self, "_on_platform_exited")

func _physics_process(delta : float) -> void:
	poll_death()
	update_combat_variables()
	player_controller.update(delta)
	update_animation()
	update_movement()

func enable(enabled : bool) -> void:
	set_physics_process(enabled)
	hitbox.set_physics_process(enabled)
	sword.enable(enabled)
	if enabled:
		animation_player.play(get_animation_key())
	else:
		animation_player.stop(false)

func tween_to_position(target_position : Vector2) -> void:
	in_transition = true
	reset_combat_variables()
	vector = Vector2()
	tween.interpolate_property(self, "position", position, target_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func get_equipment() -> Equipment:
	return equipment

func get_animation_key() -> String:
	var key = str(anim_state , anim_direction)
	if anim_direction in animation_states_with_shield:
		key = str("shield", equipment.get_ability("shield"), key)
	return key

#Signal callbacks
func _on_item_used() -> void:
	animation_player.stop()

func _on_tween_completed(other, key) -> void:
	in_transition = false

#Override
func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	if not sword.overrides_interaction(other_hitbox):
		interactions.resolve_interaction(hitbox, other_hitbox)
