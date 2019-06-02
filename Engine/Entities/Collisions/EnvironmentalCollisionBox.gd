extends Area2D
class_name EnvironmentalCollisionBox

signal hazard_tile_entered(tile_type)
signal external_force_entered(vector, magnitude)
signal external_force_exited(vector, magnitude)

func apply_external_force(vector : Vector2, magnitude : float) -> void:
	emit_signal("external_force_entered", vector, magnitude)
	
func remove_external_force(vector : Vector2, magnitude : float) -> void:
	emit_signal("external_force_exited", vector, magnitude)
	
func notify_tile_entered(tile_type) -> void:
	emit_signal("hazard_tile_entered", tile_type)