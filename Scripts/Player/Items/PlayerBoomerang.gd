extends PlayerItem
class_name PlayerBoomerang

var boomerang
var projectile_packed_scene = preload("res://Scenes/Player/Items/Projectiles/PlayerBoomerangProjectile.tscn") 
var use_delay := 15

func use_item(direction : String) -> void:
	_in_use = true
	_can_use = false

	#direction is useless, poll input to aim boomerang
	var input_vector := InputHelper.poll_direction_input()
	
	if input_vector == Vector2():
		match direction:
			"up":
				input_vector = Vector2.UP
			"down": 
				input_vector = Vector2.DOWN
			"left":
				input_vector = Vector2.LEFT
			"right":
				input_vector = Vector2.RIGHT
	
	boomerang = projectile_packed_scene.instance()
	boomerang.connect("returned_to_owner", self, "_on_boomerang_returned")
	boomerang.global_position = global_position
	boomerang.vector = input_vector
	boomerang.set_owner_node(self)
	emit_signal("projectile_created", boomerang)
	boomerang.throw(input_vector)

func can_use() -> bool:
	if boomerang:
		return false
	return true

func stop_use() -> void:
	if boomerang:
		boomerang.queue_free()
		boomerang = null

func enable(enabled : bool) -> void:
	if boomerang:
		boomerang.enable(enabled)

func _on_boomerang_returned() -> void:
	boomerang.queue_free()
	boomerang = null
	_can_use = true
	_in_use = false
