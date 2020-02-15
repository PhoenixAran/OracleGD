extends WallCrawler

func enable(enabled : bool) -> void:
	set_physics_process(enabled)
	if enabled:
		animation_player.play(get_animation_key())
	else:
		animation_player.stop()

