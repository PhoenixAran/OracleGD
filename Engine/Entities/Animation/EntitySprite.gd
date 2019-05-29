extends Sprite
class_name EntitySprite

export(Color, RGBA) var hit_color := Color(1, 1, 1, 0.35)
export(Color, RGBA) var default_color := Color(1, 1, 1, 1)

onready var entity := get_parent() as Entity

var _modulating := false

func _ready() -> void:
	entity.connect("entity_hit", self, "_on_hit")

func _on_hit(damage : int) -> void:
	if !_modulating:
		_modulating = true
		set_self_modulate(hit_color)

func _physics_process(delta : float) -> void:
	if !_modulating && !entity.is_intangible():
		set_self_modulate(default_color)
		_modulating = false
