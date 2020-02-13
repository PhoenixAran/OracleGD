extends NinePatchRect
class_name HUD

const HEART_ROW_SIZE := 8
const HEART_OFFSET := 8
const HEART_HEALTH_VALUE := 4

export(Vector2) var initial_heart_position := Vector2(96, 0)
export(Vector2) var key_position := Vector2(72, 0)

onready var hud_texture : Texture = preload("res://Assets/HUD/UI.png")
onready var heart_src_rects := {
	0 : Rect2(0, 0, 8, 8),
	1 : Rect2(8, 0, 8, 8),
	2 : Rect2(16, 0, 8, 8),
	3 : Rect2(24, 0, 8, 8),
	4 : Rect2(32, 0, 8, 8)
}
onready var heart_positions := []
onready var heart_count := 0
onready var font : DynamicFont = preload("res://Engine/Resources/DialogFont.tres")

func init_hud() -> void:
	GameRefs.get_player().connect("entity_hit", self, "_defer_update")
	GameRefs.get_player_equipment().connect("item_changed", self, "_defer_update")
	update_heart_counts()
	update()

func _draw() -> void:
	draw_hearts()
	draw_key_count()

func update_heart_counts() -> void:
	heart_positions.clear()
	heart_positions.append(initial_heart_position)
	heart_count = GameRefs.get_player().get_max_health() / HEART_HEALTH_VALUE
	for i in range(1, heart_count):
		var x := (i % HEART_ROW_SIZE) * HEART_OFFSET
		var y := (i / HEART_ROW_SIZE) * HEART_OFFSET
		heart_positions.append(Vector2(x, y) + heart_positions[0])

func draw_hearts() -> void:
	if GameRefs.get_player() == null:
		return
	var remaining_health := GameRefs.get_player().get_health() 
	for position in heart_positions:
		var fill_level := 0
		if remaining_health >= HEART_HEALTH_VALUE:
			fill_level = 4
			remaining_health = remaining_health - HEART_HEALTH_VALUE
		elif 0 < remaining_health and remaining_health < HEART_HEALTH_VALUE:
			fill_level = remaining_health
			remaining_health = 0
		draw_texture_rect_region(hud_texture, Rect2(position, Vector2(8, 8)), heart_src_rects[fill_level])

func draw_key_count() -> void:
	if GameRefs.get_player() == null:
		return
	
	if not GameRefs.get_player_equipment().has_item_key("keys"):
		return
	
	var key_count = GameRefs.get_player_equipment().get_item("keys")
	
	draw_texture_rect_region(hud_texture, Rect2(key_position, Vector2(8, 8)), Rect2(0, 8, 8, 8))
	draw_texture_rect_region(hud_texture, Rect2(key_position + Vector2(8, 0), Vector2(8, 8)), Rect2(8, 8, 8, 8))
	Numbers.draw_number(self, key_position + Vector2(16, 0), key_count, 0, 9, 0)

func _on_player_take_damage(damage : int) -> void:
	call_deferred("update")

func _defer_update() -> void:
	call_deferred("update")
