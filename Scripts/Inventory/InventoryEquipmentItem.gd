extends Sprite
class_name InventoryEquipmentItem

export(Vector2) var slot_position : Vector2
export(PackedScene) var item_scene : PackedScene

func get_item():
	return item_scene.instance()
