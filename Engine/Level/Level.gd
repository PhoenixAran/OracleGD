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

var player : Player
var target_room : Room
var current_room : Room
var previous_room : Room
var event_stack := []
var current_event : RoomEvent

func _ready() -> void:
	entity_placer.connect("entity_created", self, "_on_entity_created")
	for node in get_children():
		if node is Room:
			node.connect("request_load", self, "_on_room_request_load")

func _physics_process(delta : float) -> void:
	match room_state:
		RoomProcessState.NOT_ACTIVE:
			#Nothing to process
			pass
		RoomProcessState.PROCESSING_INITIAL:
			current_event = event_stack.pop_front()
			current_event.initialize(self)
			current_event.begin()
			room_state = RoomProcessState.PROCESSING
		RoomProcessState.PROCESSING:
			current_event.update(delta)
			if not current_event.is_active:
				current_event.end()
				if event_stack.size() > 0:
					current_event = event_stack.pop_front()
					current_event.initialize(self)
					current_event.begin()
				else:
					current_event = null
					room_state = RoomProcessState.NOT_ACTIVE
	
func initialize_level(player_entity, room = null, spawn_coordinate = null) -> void:
	player = player_entity
	if room == null:
		room = initial_room
	current_room = get_node(room) as Room
	if spawn_coordinate == null:
		spawn_coordinate = current_room.default_spawn_coordinate
	player.position = get_position_from_coordinate(spawn_coordinate)
	current_room.load_room(entity_placer)
	player.get_node("PlayerCamera").force_set_limits(current_room)

func get_position_from_coordinate(spawn_coordinate : Vector2) -> Vector2:
	return Vector2(spawn_coordinate.x * tile_width, spawn_coordinate.y * tile_height)

func set_up_new_room(target_room : Room) -> void:
	target_room.load_room(entity_placer, previous_room == target_room)
	previous_room = current_room
	current_room = target_room

func unload_last_room() -> void:
	previous_room.unload_room()
	transition_queued = false

func enable(enabled : bool) -> void:
	current_room.enable(enabled)

#signal callbacks
func _on_entity_created(entity) -> void:
	#order matters here. need to add child before
	#disabling the entity
	ysort.call_deferred("add_child", entity)
	if transition_queued:
		entity.call_deferred("enable", false)
	
	
func _on_room_request_load(room : Room, event : RoomEvent) -> void:
	if not transition_queued and room != current_room:
		target_room = room
		room_state = RoomProcessState.PROCESSING_INITIAL
		transition_queued = true
		event_stack.push_front(event)