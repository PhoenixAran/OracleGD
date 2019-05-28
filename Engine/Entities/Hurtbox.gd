extends Hitbox
class_name Hurtbox

export(int) var armor := 0
export(bool) var only_detect := false

onready var entity := get_parent() as Entity

func _physics_process(delta : float) -> void:
    if !only_detect:
        check_collisions()

func take_damage(other : Hitbox) -> Dictionary:
    if entity.is_intangible():
        return _create_damage_response()

    var damage_taken := entity.take_damage()
    _create_damage_response(damage_taken, reflect_value)
