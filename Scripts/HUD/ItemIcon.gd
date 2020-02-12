extends Sprite
class_name ItemIcon

export(bool) var counts_amount := false setget, has_amount
export(String) var item_key := "" setget, get_item_key

func has_amount() -> bool:
	return counts_amount

func get_item_key() -> String:
	return item_key

func _draw() -> void:
	if has_amount():
		
		pass
