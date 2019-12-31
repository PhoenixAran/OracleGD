extends CombatEntity
class_name Player

const animation_states_with_shield := ["idle", "move"]

signal item_changed(item)
signal sword_changed(sword)

#Nodes / Resources
onready var player_controller := $PlayerController as StateMachine
onready var environment_state_machine := $EnvironmentStateMachine as StateMachine
onready var sprite := $EntitySprite as EntitySprite
onready var tween := $Tween as Tween
onready var equipment := $Equipment as Equipment
onready var item_slot_a := $ItemSlotA as ItemSlot
onready var item_slot_b := $ItemSlotB as ItemSlot

#Declarations
var in_transition := false

#Godot API 
func _ready() -> void:
	reset_movement_variables()
	player_controller.initialize(self)
	environment_state_machine.initialize(self)

	interactions.set_interaction(CollisionType.MONSTER, Interactions.Damage)
	
	connect("entity_bumped", player_controller, "_on_entity_bumped")
	connect("entity_hit", player_controller, "_on_entity_hit")
	connect("entity_hit", item_slot_a, "_on_owner_hit")
	connect("entity_hit", item_slot_b, "_on_owner_hit")
	
	item_slot_a.connect("item_used", self, "_on_item_used")
	item_slot_b.connect("item_used", self, "_on_item_used")
	
	tween.connect("tween_completed", self, "_on_tween_completed")
	
	ecb.connect("platform_entered", self, "_on_platform_entered")
	ecb.connect("platform_exited", self, "_on_platform_exited")

func _physics_process(delta : float) -> void:
	poll_death()
	update_combat_variables()
	player_controller.update(delta)
	update_animation()
	environment_state_machine.update(delta)

func enable(enabled : bool) -> void:
	set_physics_process(enabled)
	hitbox.set_physics_process(enabled)
	item_slot_a.enable(enabled)
	item_slot_b.enable(enabled)
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
	var key := str(anim_state , anim_direction)
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
	if not (item_slot_a.overrides_interaction(other_hitbox) or item_slot_b.overrides_interaction(other_hitbox)):
		interactions.resolve_interaction(hitbox, other_hitbox)

func get_active_item_slot() -> ItemSlot:
	if item_slot_a.is_active():
		return item_slot_a
	
	if item_slot_b.is_active():
		return item_slot_b
	
	return null
