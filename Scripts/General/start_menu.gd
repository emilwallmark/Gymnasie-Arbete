extends Control

func _ready() -> void:
	AudioController.play_menu_music()
	AudioController.stop_bg_music()

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

func _on_quit_pressed() -> void:
	AudioController.play_button_sound()
	get_tree().quit()


#Counts the amout of lines of code 
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
