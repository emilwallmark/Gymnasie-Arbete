extends Control

@onready var main = $"../../"

func _on_resume_pressed() -> void:
	AudioController.play_button_sound()
	main.pauseMenu()


func _on_menu_pressed() -> void:
	AudioController.play_button_sound()
	main.pauseMenu()
	get_tree().change_scene_to_file("res://Scenes/General/start_menu.tscn")
	
