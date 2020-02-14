extends RoomEvent
class_name PushTransition

var player
var camera
var target_room
var level
var target_player_position : Vector2
var direction

var player_transition_completed := false
var camera_transition_completed := false

func get_push_transition_entrance_point(direction) -> Vector2:
	var target_coordinate_value := 0.0
	var return_vector := Vector2()

	match direction:
		Direction.UP:
			target_coordinate_value = target_room.get_bottom_right_tile().y + 0.6
		Direction.DOWN:
			target_coordinate_value = target_room.get_upper_left_tile().y + 1.4
		Direction.LEFT:
			target_coordinate_value = target_room.get_bottom_right_tile().x + 0.6
		Direction.RIGHT:
			target_coordinate_value = target_room.get_upper_left_tile().x + .4
	
	if direction == Direction.UP or direction == Direction.DOWN:
		return_vector = Vector2(player.global_position.x, target_coordinate_value * target_room.tile_height)
	else:
		return_vector = Vector2(target_coordinate_value * target_room.tile_height, player.global_position.y)
	return return_vector

func initialize(level_context) -> void:
	player_transition_completed = false
	camera_transition_completed = false
	set_active(true)
	level = level_context
	player = level.player
	player.connect("position_tween_completed", self, "_on_player_tween_completed")
	camera = player.get_node("PlayerCamera")
	camera.connect("position_tween_completed", self, "_on_camera_tween_completed")
	target_room = level.target_room
	target_player_position = get_push_transition_entrance_point(direction)

func begin() -> void:
	level.enable(false)
	player.enable(false)
	player.tween_to_position(target_player_position)
	camera.set_limits(target_room)
	level.set_up_new_room(target_room)

func update(delta : float) -> void:
	if player_transition_completed and camera_transition_completed:
		set_active(false)

func end() -> void:
	level.unload_last_room()
	level.target_room = null
	level.enable(true)
	player.enable(true)
	level.transition_queued = false

func _on_player_tween_completed() -> void:
	player_transition_completed = true

func _on_camera_tween_completed() -> void:
	camera_transition_completed = true
