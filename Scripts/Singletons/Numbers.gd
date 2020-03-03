extends Node

var number_texture : Texture = preload("res://Assets/UI/numbers.png") setget, get_number_texture
var number_src_rects := [
	Rect2(0, 0, 6, 6),
	Rect2(6, 0, 6, 6),
	Rect2(12, 0, 6, 6),
	Rect2(18, 0, 6, 6),
	Rect2(24, 0, 6, 6),
	Rect2(30, 0, 6, 6),
	Rect2(36, 0, 6, 6),
	Rect2(42, 0, 6, 6),
	Rect2(48, 0, 6, 6),
	Rect2(54, 0, 6, 6)
] setget, get_number_src_rects

func get_number_texture() -> Texture:
	return number_texture

func get_number_src_rects() -> Array:
	return number_src_rects

func get_number_src_rect(digit : int) -> Rect2:
	return number_src_rects[digit]

func draw_number(request_obj : CanvasItem, pos : Vector2, number : int, min_value := 0, max_value := 99, zero_pad := 0, digit_margin := 0) -> void:
	number = clamp(number, min_value, max_value) as int
	var number_str := str(number)
	var digits_drawn := 0
	if zero_pad > 0 and number_str.length() < zero_pad:
		for i in range(zero_pad - number_str.length()):
			draw_digit(request_obj, pos, 0)
			pos = pos + Vector2(6 + digit_margin, 0)
			digits_drawn += 1
	
	for i in range(digits_drawn, number_str.length()):
		draw_digit(request_obj, pos, int(number_str[i]))
		pos = pos + Vector2(6 + digit_margin, 0)

func draw_digit(request_obj : CanvasItem, pos : Vector2, digit : int) -> void:
	var src_rect := get_number_src_rect(digit)
	request_obj.draw_texture_rect_region(number_texture, Rect2(pos, Vector2(6, 6)), src_rect)
