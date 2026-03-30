extends Control

@onready var main = $"../../"

func _ready() -> void:
	if Globals.cheating:
		$ColorRect/CenterContainer/VBoxContainer/Submit.disabled = true

func _on_visibility_changed() -> void:
	$ColorRect/CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Score.text = str(get_parent().get_parent().wave-1)
"""
Syfte: Visa vilket score man fick den rundan
"""
func _on_menu_pressed() -> void:
	AudioController.play_button_sound()
	main.deathMenu()
	get_tree().change_scene_to_file("res://Scenes/General/start_menu.tscn")
"""
Syfte: Körs då kanppen menu är tryckt, återställer spelet till starmenyn
"""


func _on_submit_pressed() -> void:
	Globals.score = get_parent().get_parent().wave - 1
	$ColorRect/GetPlayerName.show()
	$ColorRect/CenterContainer/VBoxContainer/Submit.disabled = true
"""
Syfte: Om man vill lägga upp sitt score på leaderboarden så sparar knappen ditt score 
	   och öppnar menyn för att spara score
"""
