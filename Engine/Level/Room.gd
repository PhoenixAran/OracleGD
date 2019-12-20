extends Node
class_name Room

signal request_load(room, load_event)
signal entity_created(entity)

export(int) var tile_width := 16
export(int) var tile_height := 16
export(int) var max_refuse_load = 2
export(Vector2) var upper_left_tile : Vector2
export(Vector2) var bottom_right_tile : Vector2
export(Vector2) var default_spawn_coordinate : Vector2

var all_enemies_destroyed := false
var refuse_load_count := 0
var entity_spawners := []

#Dynamic objects
var entities := []
var projectiles := []
var dynamic_tiles := []


func _ready() -> void:
	for node in get_children():
		if node is RoomLoadingZone:
			node.connect("loading_zone_activated", self, "_on_loading_zone_activated")
		elif node is EntitySpawn:
			entity_spawners.append(node)

func get_upper_left_tile() -> Vector2:
	return upper_left_tile

func get_bottom_left_tile() -> Vector2:
	return Vector2(upper_left_tile.x, bottom_right_tile.y)

func get_bottom_right_tile() -> Vector2:
	return bottom_right_tile

func get_upper_right_tile() -> Vector2:
	return Vector2(bottom_right_tile.x, upper_left_tile.y)

func get_position_from_tile(vector : Vector2) -> Vector2:
	return Vector2(vector.x * tile_width, vector.y * tile_height)

func get_limit_top() -> int:
	return int(get_position_from_tile(upper_left_tile).y)

func get_limit_left() -> int:
	return int(get_position_from_tile(upper_left_tile).x)

func get_limit_bottom() -> int:
	return int(get_position_from_tile(bottom_right_tile).y) + tile_height

func get_limit_right() -> int:
	return int(get_position_from_tile(bottom_right_tile).x) + tile_width

func load_room(was_last_room := false) -> void:
	if was_last_room and all_enemies_destroyed:
		if refuse_load_count < max_refuse_load:
			refuse_load_count += 1
			#exit out early
			return
	
	refuse_load_count = 0
	all_enemies_destroyed = false
	for spawner in entity_spawners:
		var new_entity = spawner.spawn()
		add_entity(new_entity)
		emit_signal("entity_created", new_entity)

func unload_room() -> void:
	while not entities.empty():
		var entity = entities.pop_front()
		entity.queue_free()
	
	while not projectiles.empty():
		var projectile = projectiles.pop_front()
		projectile.queue_free()
	
	while not dynamic_tiles.empty():
		var dynamic_tile = dynamic_tiles.pop_front()
		dynamic_tile.queue_free()
		


func add_entity(entity : Entity) -> void:
	entities.append(entity)
	entity.connect("entity_destroyed", self, "_on_entity_destroyed")

func enable(enabled : bool) -> void:
	for entity in entities:
		entity.enable(enabled)
		
	for projectile in projectiles:
		projectile.enable(enabled)


#Signal callbacks
func _on_entity_destroyed(entity : Entity) -> void:
	entities.remove(entities.find(entity))
	all_enemies_destroyed = entities.size() == 0

func _on_projectile_destroyed(projectile) -> void:
	projectiles.remove(projectiles.find(projectile))

func _on_dynamic_tile_destroyed(tile : DynamicTile) -> void:
	dynamic_tiles.remove(dynamic_tiles.find(tile))

func _on_loading_zone_activated(event):
	emit_signal("request_load", self, event)
