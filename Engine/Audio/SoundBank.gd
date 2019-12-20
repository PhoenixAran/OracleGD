extends Node
class_name SoundBank

func play_sound(name : String) -> void:
	var stream_player := get_node(name) as AudioStreamPlayer
	if stream_player.playing:
		stream_player.stop()
	stream_player.play()

func stop_sound(name : String) -> void:
	var stream_player := get_node(name) as AudioStreamPlayer
	if stream_player.playing:
		stream_player.stop()
