extends State
class_name PlayerAttack

var player : Entity
var item : Item

func initialize(context) -> void:
	player = context as Entity

func begin() -> void:
	player.anim_state = "attack"
	player.update_animation()
	item = player.get_node("Item") as Item
	item.use_item(player.anim_direction)


func update(delta : float) -> void:
	if not item.in_use():
		if player.in_knockback():
			_change_state("PlayerKnockback")
		else:
			_change_state("PlayerIdle")
