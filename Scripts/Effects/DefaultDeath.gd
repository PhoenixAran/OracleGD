extends Node2D
class_name DefaultDeath

onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	animation_player.connect("animation_finished", self, "destroy")
	animation_player.call_deferred("play", "death")

func destroy(anim_name : String) -> void:
	queue_free() 
