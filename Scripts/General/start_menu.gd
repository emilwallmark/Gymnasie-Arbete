extends Control

func _ready() -> void:
	AudioController.play_menu_music()
	AudioController.stop_bg_music()
"""
Syfte: Kör rätt musik då startmenys visas
"""

func _on_start_button_pressed() -> void:
	Globals.money = 0
	Globals.player_max_lives = 5
	Globals.player_lives = 5
	Globals.dead = false
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
	if int($TextEdit.text) > 10000:
		Cheats.emit_when_ready(10000)
	else:
		Cheats.emit_when_ready(int($TextEdit.text))
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

#
#var count_code := 0
#var count_comments := 0
#var count_total := 0
 #
 #
#func _ready():
	#count_dir("res://")
	#OS.alert("%s lines of code\n%s comments\n%s total lines" % [count_code, count_comments, count_total])
 #
 #
#func count_dir(path: String):
	#var directories = DirAccess.get_directories_at(path)
	#for d in directories:
		#if d == "addons":
			#continue
		#if path == "res://":
			#count_dir(path + d)
		#else:
			#count_dir(path + "/" + d)
	#
	#var files = DirAccess.get_files_at(path)
	#
	#for f in files:
		#if not f.get_extension() == "gd":
			#continue
		#var file := FileAccess.open(path + "/" + f, FileAccess.READ)
		#var lines = file.get_as_text().split("\n")
		#
		#for line in lines:
			#count_total += 1
			#if line.strip_edges().begins_with("#"):
				#count_comments += 1
				#continue
			#if line.strip_edges() != "":
				#count_code += 1
