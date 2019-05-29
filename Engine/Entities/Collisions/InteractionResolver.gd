class_name InteractionResolver

var _interaction_map := { }
var _default_interaction := DamageInteraction.new()

func set_interaction(type, interaction : Interaction) -> void:
	_interaction_map[type] = interaction
	
func get_interaction(type : Interaction) -> Interaction:
	return _interaction_map[type] as Interaction

func has_interaction(type) -> bool:
	return _interaction_map.has(type)
	
func resolve_interaction(receiver : Hitbox, sender : Hitbox) -> void:
	var type = sender.TYPE
	if has_interaction(type):
		get_interaction(type).resolve(receiver, sender)
	else:
		_default_interaction.resolve(receiver, sender)
	
