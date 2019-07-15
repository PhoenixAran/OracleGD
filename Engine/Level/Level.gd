extends Node2D
class_name Level

enum RoomProcessState {
	NOT_ACTIVE,
	PROCESSING_INITIAL,
	PROCESSING
}

export(int) var tile_width := 16
export(int) var tile_height := 16
export(String) var initial_room : String

onready var entity_placer = $EntityPlacer as EntityPlacer
onready var ysort := $YSort as YSort

var room_state = RoomProcessState.NOT_ACTIVE
var transition_queued := false

var player
var current_room : Room = null
var previous_room : Room = null
var event_stack := []
var current_event 

func _ready() -> void:
	entity_placer.connect("entity_created", self, "_on_entity_created")

func _physics_process(delta : float) -> void:
	match room_state:
		RoomProcessState.NOT_ACTIVE:
			#Nothing to process
			pass
		RoomProcessState.PROCESSING_INITIAL:
			current_event = event_stack.pop_front()
			pass
		RoomProcessState.PROCESSING:
			pass
	
func initialize_level(player_entity, room = null, spawn_coordinate = null) -> void:
	player = player_entity
	if room == null:
		room = initial_room
	current_room = get_node(room)
	if spawn_coordinate == null:
		spawn_coordinate = current_room.default_spawn_coordinate
	player.position = get_position_from_coordinate(spawn_coordinate)

func get_position_from_coordinate(spawn_coordinate : Vector2) -> Vector2:
	return Vector2(spawn_coordinate.x * tile_width, spawn_coordinate.y * tile_height)

func set_up_new_room(target_room : Room) -> void:
	target_room.load_room(entity_placer, previous_room == target_room)
	previous_room = current_room
	current_room = target_room

func unload_last_room() -> void:
	previous_room.unload_room()
	transition_queued = false

#signal callbacks
func _on_entity_created(entity) -> void:
	if transition_queued:
		entity.call_deferred("enable", false)
	ysort.call_deferred("add_child", entity)
	
func _on_room_request_load(room : Room, event) -> void:
	if not transition_queued:
		room_state = RoomProcessState.PROCESSING_INITIAL
		transition_queued = true
		event_stack.push_front(event)