extends Node
class_name Health

export(int) var _max_health := 4 setget set_max_health, get_max_health
export(int) var _health := 4 setget set_health, get_health
export(int) var armor := 0

signal max_health_changed(new_max_health)
signal health_changed(health)
signal health_depleted

func get_max_health() -> int:
	return _max_health

func set_max_health(value : int) -> void:
	_max_health = value
	emit_signal("max_health_changed", _max_health)
	if value < _health:
    	emit_signal("damage_taken", _health - value)
    	_health = value

func get_health() -> int:
	return _health

func set_health(value : int) -> void:
	_health = value
	emit_signal("health_changed", _health)
	if value <= 0:
		emit_signal("health_depleted")

func take_damage( damage : int ) -> void:
	if 0 < damage:
		var actual_damage := damage - armor
		if 0 < actual_damage:
			_health -= damage - armor
			emit_signal("health_changed", _health)
		if _health <= 0:
			emit_signal("health_depleted", actual_damage)

func heal( amount : int ) -> void:
	assert(amount >= 0)
	_health = clamp(_health + amount, 0, _max_health)
	emit_signal("health_changed", _health)

func is_depleted() -> bool:
	return _health <= 0
