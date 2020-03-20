extends PlayerItem
class_name PlayerBow

export(int) var arrow_limit := 3
export(int) var use_delay := 3

var arrows := []
var arrow_projectile_scene = preload("res://Scenes/Player/Items/Projectiles/PlayerArrowProjectile.tscn")

func use_item(direction : String) -> void:
	var input_vector := InputHelper.poll_4_way_direction_input()
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
	
	var projectile = arrow_projectile_scene.instance()
	projectile.global_position = global_position
	projectile.connect("projectile_destroyed", self, "_on_projectile_destroyed")
	emit_signal("projectile_created", projectile)
	projectile.shoot(input_vector)
	arrows.append(projectile)

func can_use() -> bool:
	return 3 > arrows.size()

func _on_projectile_destroyed(arrow) -> void:
	print("PlayerBow::_on_projectile_destroyed")
	arrows.remove(arrows.find(arrow))
