extends Entity
class_name Player

onready var player_controller := $PlayerController as StateMachine

func _ready() -> void:
	player_controller.initialize()
