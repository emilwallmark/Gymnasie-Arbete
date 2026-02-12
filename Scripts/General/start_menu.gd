extends Control

func _on_start_button_pressed() -> void:
	Globals.money = 0
	Globals.player_max_lives = 5
	Globals.player_lives = 5
	Globals.dead = false
	Engine.time_scale = 1
	
	get_tree().change_scene_to_file("res://Scenes/General/level.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
