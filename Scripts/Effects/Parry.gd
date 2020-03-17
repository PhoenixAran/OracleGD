#Parry.gd
extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "destroy")
	$AnimationPlayer.call_deferred("play", "parry")

func destroy(key):
	queue_free()
