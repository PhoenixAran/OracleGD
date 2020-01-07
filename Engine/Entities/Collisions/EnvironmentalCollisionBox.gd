extends Node2D
class_name EnvironmentalCollisionBox

#Signals
signal tile_entered(tile)
signal platform_entered(platform)
signal platform_exited(platform)

#Nodes
onready var tile_collision_box := $TileCollisionBox as Area2D
onready var platform_collision_box := $PlatformCollisionBox as Area2D

#Declarations
var current_platform
var current_tile

func _physics_process(delta : float) -> void:
	var intersecting_tiles
	var intersecting_platforms
	
	#check if we're still on a platform if we cached it
	if current_platform != null:
		if not current_platform.overlaps_area(platform_collision_box):
			emit_signal("platform_exited", current_platform.get_parent())
			current_platform = null
	elif current_tile != null:
		if not current_tile.overlaps_area(tile_collision_box):
			emit_signal("platform_exited", current_platform.get_parent())
			current_tile = null
	
	#if we're not on a platform, check for new ones
	if current_platform == null:
		intersecting_platforms = platform_collision_box.get_overlapping_areas()
		if intersecting_platforms.size() > 0:
			current_platform = intersecting_platforms[0]
			emit_signal("platform_entered", current_platform.get_parent())
	
	#if current platform is null at this point, we are not on a platform
	#therefore, we care about dynamic tile collisions now
	if current_platform == null:
		intersecting_tiles = tile_collision_box.get_overlapping_areas()
		if intersecting_tiles.size() > 0:
			var tile = intersecting_tiles[0]
			emit_signal("tile_entered", tile)
