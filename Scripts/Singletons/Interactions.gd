#Autoload
extends Node

#Holds basic interactions for all entities to share
onready var damage := DamageInteraction.new() as DamageInteraction
onready var ignore := IgnoreInteraction.new() as IgnoreInteraction
onready var damage_other := DamageOtherInteraction.new() as DamageOtherInteraction

