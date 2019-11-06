extends Node
#AUTOLOAD

#Holds basic interactions for all entities to share
onready var Damage := DamageInteraction.new() as DamageInteraction
onready var Ignore := Interaction.new() as Interaction


