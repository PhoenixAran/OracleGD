extends Node2D
class_name DefaultDeath

onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	animation_player.connect("animation_finished", self, "destroy")
	animation_player.play("death")

func destroy() -> void:
	queue_free() 