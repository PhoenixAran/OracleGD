extends NinePatchRect
class_name HUD

const HEART_ROW_SIZE := 8
const HEART_OFFSET := 8
const HEART_HEALTH_VALUE := 4

export(Vector2) var initial_heart_position := Vector2(96, 0)
export(Vector2) var key_position := Vector2(72, 0)
export(Vector2) var rupee_count_position := Vector2(92, 0)

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
onready var item_icon_texture: Texture = preload("res://Assets/HUD/placeholder_item_icons.png")

func init_hud() -> void:
	GameRefs.get_player().connect("entity_hit", self, "_defer_update")
	GameRefs.get_player_equipment().connect("item_changed", self, "_defer_update")
	update_heart_counts()
	update()

func _draw() -> void:
	draw_hearts()
	draw_key_count()
	draw_rupee_count()
	draw_item_icon_borders()
	draw_place_holder_item_icons()

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

func draw_rupee_count() -> void:
	if GameRefs.get_player() == null:
		return
	
	if not GameRefs.get_player_equipment().has_item_key("rupees"):
		return
	
	var rupee_count = GameRefs.get_player_equipment().get_item("rupees")
	Numbers.draw_number(self, rupee_count_position, rupee_count, 0, 999, 3, 2)

func draw_item_icon_borders() -> void:
	#draw the b item bracket
	draw_texture_rect_region(hud_texture, Rect2(0, 0, 8, 8), Rect2(16, 24, 8, 8))
	draw_texture_rect_region(hud_texture, Rect2(0, 8, 8, 8), Rect2(32, 16, 8, 8))
	draw_texture_rect_region(hud_texture, Rect2(30, 0, 8, 16), Rect2(40, 8, 8, 16))
	
	#draw the a item bracket
	draw_texture_rect_region(hud_texture, Rect2(34, 0, 8, 8), Rect2(0, 24, 8, 8))
	draw_texture_rect_region(hud_texture, Rect2(34, 8, 8, 8), Rect2(32, 16, 8, 8))
	draw_texture_rect_region(hud_texture, Rect2(64, 0, 8, 16), Rect2(40, 8, 8, 16))

#Sword icon is hardcoded, change later when the time comes
func draw_place_holder_item_icons() -> void:
	draw_texture_rect_region(item_icon_texture, Rect2(8, 0, 16, 16), Rect2(0, 0, 16, 16))
	draw_texture_rect_region(hud_texture, Rect2(16, 8, 8, 8), Rect2(0, 16, 8, 8))
	Numbers.draw_number(self, Vector2(24, 9), 1, 0, 3)

func _defer_update() -> void:
	call_deferred("update")
