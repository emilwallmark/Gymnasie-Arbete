extends Control

@onready var line_edit: LineEdit = $LineEdit


func _on_submit_pressed() -> void:
	hide()
	Globals.player_name = line_edit.text
	
	$Submit.disabled = true
	Engine.time_scale = 1
	
	var sw_result = await SilentWolf.Scores.save_score(
		Globals.player_name, 
		Globals.score
	).sw_save_score_complete
	
	$Submit.disabled = false
	
"""
Syfte: Sparar score till leaderboard då submit knappen är tryckt
"""
