extends State
class_name PlayerAttack

var player : Entity
var item : Item

func initialize(context) -> void:
	player = context as Entity

func begin() -> void:
	player.anim_state = "attack"
	player.update_animation()
	player.vector = Vector2()
	item = player.get_node("Item") as Item
	assert(item != null)
	item.use_item(player.anim_direction)


func update(delta : float) -> void:
	if !item.in_use():
		_change_state("PlayerIdle")	
