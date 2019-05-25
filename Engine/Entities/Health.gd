extends Node
class_name Health

export(int) var _max_health := 4 setget set_max_health, get_max_health
export(int) var armor := 0
export(int) var _health := 4 setget, get_health

signal max_health_changed(new_max_health)
signal damage_taken(damage)
signal health_gained(amount_gained)
signal health_depleted

func get_max_health() -> int:
	return _max_health

func set_max_health(value) -> void:
	_max_health = value
	emit_signal("max_health_changed", _max_health)
	if value < _health:
    	emit_signal("damage_taken", _health - value)
    	_health = value

func get_health() -> int:
	return _health

func take_damage( damage : int ) -> void:
	var damage_taken := damage - armor
	emit_signal("damage_taken", damage_taken)
	_health -= damage
	if _health <= 0:
		emit_signal("health_depleted")

func heal( amount : int ) -> void:
	emit_signal("amount_gained", amount)
	_health = clamp(_health + amount, 0, _max_health)

func is_depleted() -> bool:
	return _health < 0
