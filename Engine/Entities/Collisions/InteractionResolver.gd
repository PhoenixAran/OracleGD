class_name InteractionResolver

var _interaction_map : Dictionary = { }
var _tile_interaction_map : Dictionary = { }
var _default_interaction : Interaction = Interactions.ignore
var _default_tile_interaction

#entity / hitbox interactions
func set_interaction(type, interaction : Interaction) -> void:
	_interaction_map[type] = interaction

func get_interaction(type) -> Interaction:
	return _interaction_map[type] as Interaction

func remove_interaction(type) -> void:
	_interaction_map.erase(type)

func has_interaction(type) -> bool:
	return _interaction_map.has(type)

func resolve_interaction(receiver : Hitbox, sender : Hitbox) -> void:
	var type = sender.TYPE
	if has_interaction(type):
		get_interaction(type).resolve(receiver, sender)
	else:
		_default_interaction.resolve(receiver, sender)


#tile interactions
func set_tile_interaction(type, interaction) -> void:
	_tile_interaction_map[type] = interaction

func get_tile_interaction(type):
	return _tile_interaction_map[type]

func remove_tile_interaction(type):
	_tile_interaction_map.erase(type)
	
func has_tile_interaction(type) -> bool:
	return _tile_interaction_map.has(type)

func resolve_tile_interaction(receiver, dynamic_tile) -> void:
	var type = dynamic_tile.tile_type
	if has_tile_interaction(type):
		get_tile_interaction(type).resolve(receiver, dynamic_tile)
	else:
		_default_tile_interaction.resolve(receiver, dynamic_tile)

