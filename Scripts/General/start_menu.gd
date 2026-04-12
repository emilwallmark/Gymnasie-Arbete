extends Control

var show_cheat: bool = false

func _ready() -> void:
	AudioController.play_menu_music()
	AudioController.stop_bg_music()
"""
Syfte: Kör rätt musik då startmenys visas
"""

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("activate_cheat") and not show_cheat:
		$UI/Cheat.visible = true
		$UI/TextEdit.show()
		show_cheat = true
	elif Input.is_action_just_pressed("activate_cheat") and show_cheat:
		$UI/Cheat.hide()
		$UI/TextEdit.hide()
		show_cheat = false
"""
Syfte: Visa och gömma fusk knappen
"""

func _on_start_button_pressed() -> void:
	Globals.money = 0
	Globals.player_max_lives = 5
	Globals.player_lives = 5
	Globals.dead = false
	Globals.cheating = false
	Engine.time_scale = 1
	AudioController.play_button_sound()
	AudioController.play_bg_music()
	AudioController.stop_menu_music()
	
	get_tree().change_scene_to_file("res://Scenes/General/level.tscn")
"""
Syfte: Starta spelet med rätt värden på allt då startknappen har tryckts
"""

func _on_quit_pressed() -> void:
	AudioController.play_button_sound()
	get_tree().quit()
"""
Syfte: Stänga av spelet då quitknappen har tryckts
"""

func _on_cheat_pressed() -> void:
	Globals.cheating = true
	if int($UI/TextEdit.text) > 10000:
		Cheats.emit_when_ready(10000)
	else:
		Cheats.emit_when_ready(int($UI/TextEdit.text))
	Globals.money = 10000
	Globals.player_max_lives = 100
	Globals.player_lives = 100
	Globals.dead = false
	Engine.time_scale = 1
	AudioController.play_button_sound()
	AudioController.play_bg_music()
	AudioController.stop_menu_music()
	get_tree().change_scene_to_file("res://Scenes/General/level.tscn")
"""
Syfte: Sätter alla värden då cheatknappen har tryckts
Kommentar: Skickar en signal via cheat scripten till level och wave_manager så att man kan välja
           wave och få de andra vapen
"""

func _on_leaderboard_pressed() -> void:
	AudioController.play_button_sound()
	get_tree().change_scene_to_file("res://Scenes/Leaderboard/leaderboard.tscn")
"""
Syfte: Ändrar scene till leaderboard
"""


func _on_button_pressed() -> void:
	$Tutorial.show()
	$UI.hide()
	AudioController.play_button_sound()
