extends CombatEntity
class_name Player

const animation_states_with_shield := ["idle", "move"]

signal position_tween_completed

#Nodes / Resources
onready var player_controller := $PlayerController as StateMachine
onready var environment_state_machine := $EnvironmentStateMachine as StateMachine
onready var sprite := $EntitySprite as EntitySprite
onready var tween := $Tween as Tween
onready var equipment := $Equipment as Equipment setget, get_equipment
onready var item_slot_a := $ItemSlotA as ItemSlot
onready var item_slot_b := $ItemSlotB as ItemSlot
onready var ray_cast_1 := $RayCast1 as RayCast2D
onready var ray_cast_2 := $RayCast2 as RayCast2D

#Declarations
onready var ray_cast_direction := "down"

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
	
	tween.connect("tween_all_completed", self, "_on_tween_completed")
	
	ecb.connect("platform_entered", self, "_on_platform_entered")
	ecb.connect("platform_exited", self, "_on_platform_exited")

func _physics_process(delta : float) -> void:
	poll_death()
	update_combat_variables()
	player_controller.update(delta)
	update_animation()
	var slide_value := update_movement(delta)
	update_movement_correction(delta, slide_value)

#functions
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
	reset_combat_variables()
	vector = Vector2()
	tween.interpolate_property(self, "position", position, target_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func get_equipment() -> Equipment:
	return equipment

func get_animation_key() -> String:
	var key := str(anim_state , anim_direction)
	if equipment.get_ability("shield") > 0 and  anim_state in animation_states_with_shield:
		key = str("shield", equipment.get_ability("shield"), key)
	return key

func anim_direction_matches_vector() -> bool:
	match vector:
		Vector2.UP:
			return anim_direction == "up"
		Vector2.DOWN:
			return anim_direction == "down"
		Vector2.LEFT:
			return anim_direction == "left"
		Vector2.RIGHT:
			return anim_direction == "right"
		_:
			return false

func update_raycast_positions(force_match := false) -> void:
	if ray_cast_direction != anim_direction or force_match:
		match anim_direction:
			"left":
				ray_cast_1.cast_to = Vector2(-7, 0)
				ray_cast_1.position = Vector2(0, -2)
				ray_cast_2.cast_to = Vector2(-7, 0)
				ray_cast_2.position = Vector2(0, 2)
			"right":
				ray_cast_1.cast_to = Vector2(5, 0)
				ray_cast_1.position = Vector2(0, -2)
				ray_cast_2.cast_to = Vector2(5, 0)
				ray_cast_2.position = Vector2(0, 2)
			"up":
				ray_cast_1.cast_to = Vector2(0, -5)
				ray_cast_1.position = Vector2(-2, 0)
				ray_cast_2.cast_to = Vector2(0, -5)
				ray_cast_2.position = Vector2(2, 0)
			"down":
				ray_cast_1.cast_to = Vector2(0, 10)
				ray_cast_1.position = Vector2(-2, 0)
				ray_cast_2.cast_to = Vector2(0, 10)
				ray_cast_2.position = Vector2(2, 0)
			_:
				return
		ray_cast_direction = anim_direction
		#force update the raycasts so collisions will report the same frame
		ray_cast_1.force_raycast_update()
		ray_cast_2.force_raycast_update()

func update_movement_correction(delta : float, slide_value : Vector2) -> void:
	#if the player is moving diagonally or switched directions,
	#force update the raycast positions to their default state based on 
	#which way the player is facing
	if not anim_direction_matches_vector() and get_vector() != Vector2.ZERO:
		update_raycast_positions(true)
		return
	
	update_raycast_positions()

	#the player can stop moving mid movement correction, movement correction 
	#should resume when they start moving in the same direction so just exit out
	if player_controller.get_current_state() != "PlayerMove":
		return
	
	#this check means that the movement correction has completed so reset the
	#raycast positions and exit out
	if not is_on_wall():
		update_raycast_positions(true)
		return
	
	#if the player moved due to colliding with a slope, just exit out since
	#the engine will automatically slide the player
	if slide_value != Vector2.ZERO:
		return
	
	#manhandle slippery corner sliding so players don't get snagged on corners
	var new_vector := get_vector()
	
	#in each case we slide the opposite raycast to the end of the player's
	#collider so we know when to stop correcting the movement
	match get_vector():
		Vector2.UP:
			if not ray_cast_1.is_colliding():
				ray_cast_1.position = Vector2(-2, 0)
				ray_cast_2.position = Vector2(5, 0)
				new_vector.x = -1
			elif not ray_cast_2.is_colliding():
				ray_cast_2.position = Vector2(2, 0)
				ray_cast_1.position = Vector2(-5, 0)
				new_vector.x = 1
		Vector2.DOWN:
			if not ray_cast_1.is_colliding():
				ray_cast_1.position = Vector2(-2, 0)
				ray_cast_2.position = Vector2(5, 0)
				new_vector.x = -1
				print("adjusting ray_cast_2 position")
			elif not ray_cast_2.is_colliding():
				ray_cast_1.position = Vector2(-5, 0)
				ray_cast_2.position = Vector2(2, 0)
				new_vector.x = 1
				print("adjusting ray_cast_1 position")
		Vector2.RIGHT:
			if not ray_cast_1.is_colliding():
				ray_cast_1.position = Vector2(0, -2)
				ray_cast_2.position = Vector2(0, 4)
				new_vector.y = -1
			elif not ray_cast_2.is_colliding():
				ray_cast_2.position = Vector2(0, 2)
				ray_cast_1.position = Vector2(0, -4)
				new_vector.y = 1
			else:
				update_raycast_positions(true)
		Vector2.LEFT:
			if not ray_cast_1.is_colliding():
				ray_cast_1.position = Vector2(0, -2)
				ray_cast_2.position = Vector2(0, 4)
				new_vector.y = -1
			elif not ray_cast_2.is_colliding():
				ray_cast_2.position = Vector2(0, 2)
				ray_cast_1.position = Vector2(0, -4)
				new_vector.y = 1
				
	#if the player is not close enough to the edge to get corrected, just return
	#early to avoid unnecessary computations and an extra move_and_slide call
	if new_vector == get_vector():
		update_raycast_positions(true)
		return
	var new_linear_velocity = recalculate_linear_velocity(delta, new_vector)
	move_and_slide(new_linear_velocity, Vector2.ZERO)
	

#Signal callbacks
func _on_item_used() -> void:
	animation_player.stop()

func _on_tween_completed() -> void:
	emit_signal("position_tween_completed")

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
