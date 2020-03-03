extends TextureRect
class_name ItemIcon

enum ItemIconType {
	SIMPLE,
	SHOW_LEVEL,
	SHOW_AMMO
}

var ui_texture = preload("res://Assets/UI/UI.png")

export(ItemIconType) var icon_type = ItemIconType.SIMPLE
export(int) var item_level := 1
export(String) var ability_key := ""
export(String) var ammo_key := ""
export(PackedScene) var item_scene : PackedScene

func _draw() -> void:
	match icon_type:
		ItemIconType.SIMPLE:
			pass
		ItemIconType.SHOW_LEVEL:
			draw_level(8, 8, item_level)
			pass
		ItemIconType.SHOW_AMMO:
			pass

func draw_level(x, y, level) -> void:
	draw_texture_rect_region(ui_texture, Rect2(x, y, 8, 8), Rect2(0, 16, 8, 8))
	Numbers.draw_digit(self, Vector2(16, 9), level)
