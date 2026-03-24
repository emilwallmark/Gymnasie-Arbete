extends Node

func play_bg_music():
	$BgSound.play()

func stop_bg_music():
	$BgSound.stop()

func play_menu_music():
	$MenuSound.play()
func stop_menu_music():
	$MenuSound.stop()
func play_walking_sound():
	if $WalkSound/WalkTimer.time_left <= 0:
		$WalkSound.pitch_scale = randf_range(0.8, 1.2)
		$WalkSound.play()
		$WalkSound/WalkTimer.start(randf_range(0.3, 0.5))

func play_button_sound():
	$ButtonSound.play()

func play_buy_sound():
	$BuySound.play()

func play_error_sound():
	$ErrorSound.play()

func play_explotion_sound():
	$ExpolitionSound.play()
