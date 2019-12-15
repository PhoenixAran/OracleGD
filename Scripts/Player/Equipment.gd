extends Node
class_name Equipment

signal rebuild_player(ability, level)
signal item_change(item, amount)
signal equipment_item_change(item, resource)

const ability_causes_rebuild := ["tunic", "sword", "shield"]

export(Dictionary) var abilities := {
	"tunic" : 1,
	"sword" : 1,
	"shield" : 0,
	"lift" : 0,
	"swim" : 0
}

export(Dictionary) var items := {
	"rupees" : 0
}

export(Dictionary) var equipment_items

func get_ability(ability : String) -> int:
	assert(abilities.has(ability))
	return abilities[ability] as int

func set_ability(ability : String, level : int) -> void:
	if ability in ability_causes_rebuild:
		emit_signal("rebuild_player", ability, level)
	abilities[ability] = level

func get_item(item : String) -> int:
	assert(items.has(item))
	return items[item] as int

func set_item(item : String, amount : int) -> void:
	items[item] = amount

func get_equipment_item(key : String) -> PackedScene:
	assert(equipment_items.has(key))
	return load(equipment_items[key]) as PackedScene

func set_equipment_item(key : String, inv_equipment_item_path : String) -> void:
	emit_signal("equipment_item_change", key, inv_equipment_item_path)
	equipment_items[key]  = inv_equipment_item_path

func has_item_key(key) -> bool:
	return items.has(key)

func has_equipment_item_key(key) -> bool:
	return equipment_items.has(key)
