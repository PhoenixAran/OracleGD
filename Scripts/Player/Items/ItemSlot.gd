extends Node2D
class_name ItemSlot

signal item_used
signal owner_hit

export(String, "A", "B") var action_listen := "A"
var assigned_item : PlayerItem
var active_item := false

func _ready() -> void:
	var children := get_children()
	assert(children.size() == 1 or children.size() == 0)
	if children.size() == 1:
		set_item(children[0])
		get_item().connect("item_used", self, "_on_item_used")
		connect("owner_hit", get_item(), "_on_owner_hit")

func is_action_pressed() -> bool:
	if not has_item():
		return false
	return Input.is_action_pressed(action_listen)

func is_action_just_pressed() -> bool:
	if not has_item():
		return false
	return Input.is_action_just_pressed(action_listen)

func set_item(item : PlayerItem, free_previous := true) -> void:
	if assigned_item != null and free_previous:
		assigned_item.queue_free()
	assigned_item = item

func get_item_level() -> int:
	return assigned_item.get_item_level()

func get_item() -> PlayerItem:
	return assigned_item

func has_item() -> bool:
	return assigned_item != null

func use_item(direction : String) -> void:
	assigned_item.use_item(direction)

func stop_use() -> void:
	assigned_item.stop_use()

func get_use_state(current_state = null) -> String:
	return assigned_item.get_use_state()

func item_in_use() -> bool:
	return assigned_item.in_use()

func enable(enabled : bool) -> void:
	if assigned_item != null:
		assigned_item.enable(enabled)
	
func overrides_interaction(sender : Hitbox) -> bool:
	if assigned_item == null:
		return false
	return assigned_item.overrides_interaction(sender)

func _on_owner_hit() -> void:
	emit_signal("owner_hit")

func is_active() -> bool:
	return active_item

func set_active(value := true) -> void:
	active_item = value

func _on_item_used() -> void:
	emit_signal("item_used")
