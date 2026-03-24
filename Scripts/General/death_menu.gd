extends Control

@onready var main = $"../../"


func _on_menu_pressed() -> void:
	AudioController.play_button_sound()
	main.deathMenu()
	get_tree().change_scene_to_file("res://Scenes/General/start_menu.tscn")
	
