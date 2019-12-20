extends MarginContainer
class_name HUD

const HEART_ROW_SIZE := 8
const HEART_OFFSET := 8
const HEART_HEALTH_VALUE := 4
const HEART_DEST_RECT_SIZE := Vector2(8, 8)

onready var hud_texture : Texture = preload("res://Assets/HUD/UI.png")
onready var initial_heart_position := $HBoxContainer/InitialHeartPosition as Position2D
onready var heart_src_rects := {
	0 : Rect2(0, 0, 8, 8),
	1 : Rect2(8, 0, 8, 8),
	2 : Rect2(16, 0, 8, 8),
	3 : Rect2(24, 0, 8, 8),
	4 : Rect2(32, 0, 8, 8)
}

var heart_positions : Array 
var heart_count : int = 0

func init_hud() -> void:
	GameRefs.get_player().connect("entity_hit", self, "_on_take_damage")
	update_heart_counts()
	update()

func _draw() -> void:
	if GameRefs.get_player() == null:
		return
	print("Redrawing Hearts")
	var remaining_health := GameRefs.get_player().get_health()
	for position in heart_positions:
		var fill_level := 0
		if remaining_health >= HEART_HEALTH_VALUE:
			fill_level = 4
			remaining_health = remaining_health - HEART_HEALTH_VALUE
		elif 0 < remaining_health and remaining_health < HEART_HEALTH_VALUE:
			fill_level = remaining_health
			remaining_health = 0
		print({'fill_level' : str(fill_level)})
		draw_texture_rect_region(hud_texture, Rect2(position, HEART_DEST_RECT_SIZE), heart_src_rects[fill_level])

func update_heart_counts() -> void:
	heart_positions = [initial_heart_position.global_position]
	heart_count = int(GameRefs.get_player().get_max_health() / HEART_HEALTH_VALUE)
	for i in range(1, heart_count):
		var x := int(i % HEART_ROW_SIZE) * HEART_OFFSET
		var y := int(i / HEART_ROW_SIZE) * HEART_OFFSET
		heart_positions.append(Vector2(x, y) + heart_positions[0])

func _on_take_damage(damage : int) -> void:
	update()

