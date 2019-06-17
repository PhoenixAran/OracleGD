extends Sprite
class_name EntitySprite

export(Color, RGBA) var hit_color := Color(1, 1, 1, 0.35)
export(Color, RGBA) var default_color := Color(1, 1, 1, 1)

var modulating := false
onready var entity := get_parent() as Entity

func _physics_process(delta : float) -> void:
	if modulating and entity.is_intangible():
		set_self_modulate(hit_color)

func _on_entity_hit() -> void:
	#only set entity to be clear if the owner is intangible
	if entity.is_intangible():
		modulating = true
		set_self_modulate(hit_color)
