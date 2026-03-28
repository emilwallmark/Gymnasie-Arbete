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

func play_player_hurt_sound():
	$PlayerHurtSound.play()

func play_boss_walking_sound():
	if $BossWalkSound/WalkTimer.time_left <= 0:
		$BossWalkSound.pitch_scale = randf_range(0.8, 1.2)
		$BossWalkSound.play()
		$BossWalkSound/WalkTimer.start(randf_range(0.7, 1))

func play_button_sound():
	$ButtonSound.play()

func play_buy_sound():
	$BuySound.play()

func play_error_sound():
	$ErrorSound.play()

func play_explotion_sound():
	$ExpolitionSound.play()

func play_sword_sound():
	$SwordSound.play()
	
func play_gun_sound():
	$GunSound.play()

func play_heavy_gun_sound():
	$HeavyGunSound.play()

func play_blaster_sound():
	$BlasterSound.play()

func play_sniper_sound():
	$SniperSound.play()

func play_rocket_launcher_sound():
	$RocketLauncherSound.play()
	
func play_boss_attack_1_sound():
	$BossAttack1nJumpSound.play()

func play_swosh_sound():
	$SwoshSound.play()

func play_screech_sound():
	$ScreechSound.play()

func play_boss_die_sound():
	$BossDieSound.play()

func play_lose_sound():
	$LoseSound.play()
	
func play_splitter_die_sound():
	$SplitterDieSound.play()

func play_summon_sound():
	$SummonSound.play()
