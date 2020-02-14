#Autoload
extends Node

var default_font : DynamicFont = preload("res://Engine/Resources/DialogFont.tres") setget, get_default_font

var unit_size := 16 setget, get_unit_size
var screen_width := 160 setget, get_screen_width
var screen_height := 144 setget, get_screen_height

func _ready():
	randomize()

func get_default_font() -> DynamicFont:
	return default_font

func get_unit_size() -> int:
	return unit_size

func get_screen_width() -> int:
	return screen_width

func get_screen_height() -> int:
	return screen_height
