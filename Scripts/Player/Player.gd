extends Entity
class_name Player

onready var player_controller := $PlayerController as StateMachine
onready var hitbox := $Hitbox as Hitbox


func _ready() -> void:
	player_controller.initialize()
	
#Signal callbacks
func _on_hitbox_entered(other_hitbox : Hitbox) -> void:
	interactions.resolve_interaction(hitbox, other_hitbox)