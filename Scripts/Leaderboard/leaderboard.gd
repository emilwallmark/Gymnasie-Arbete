extends GridContainer

var player_list_with_pos = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1

	await get_tree().create_timer(0.2).timeout
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete

	for child in get_children():
		child.queue_free()
	player_list_with_pos = sort_players_and_add_position(SilentWolf.Scores.scores)
	add_player_to_grid(player_list_with_pos)
"""
Syfte: Läser in alla scores som finns på leaderboarden
"""

func add_player_to_grid(player_list):
	var pos_vbox = VBoxContainer.new()
	var name_vbox = VBoxContainer.new()
	var score_vbox = VBoxContainer.new()
	
	for score_data in player_list_with_pos:
		var pos_label = Label.new()
		var font = load("res://Fonts/Darinia.ttf")
		pos_label.text =  "     " +  str(score_data["position"])
		pos_label.show()
		pos_label.add_theme_font_size_override("font_size", 75)
		pos_label.add_theme_font_override("font", font)
		pos_label.add_theme_color_override("font_shadow_color", Color(0,0,0,1))
		pos_label.add_theme_constant_override("shadow_offset_x", 5)
		pos_label.add_theme_constant_override("shadow_offset_y", 5)
		pos_vbox.add_child(pos_label)
	add_child(pos_vbox)
	
	for score_data in player_list_with_pos:
		var name_label = Label.new()
		var font = load("res://Fonts/OldeTome.ttf")
		name_label.text = str(score_data["player_name"])
		name_label.show()
		name_label.add_theme_font_size_override("font_size", 75)
		name_label.add_theme_font_override("font", font)
		name_label.add_theme_color_override("font_shadow_color", Color(0,0,0,1))
		name_label.add_theme_constant_override("shadow_offset_x", 5)
		name_label.add_theme_constant_override("shadow_offset_y", 5)
		name_vbox.add_child(name_label)
	add_child(name_vbox)

	for score_data in player_list_with_pos:
		var score_label = Label.new()
		var font = load("res://Fonts/Darinia.ttf")
		score_label.text = str(int(score_data["score"]))
		score_label.show()
		score_label.add_theme_font_size_override("font_size", 75)
		score_label.add_theme_font_override("font", font)
		score_label.add_theme_color_override("font_shadow_color", Color(0,0,0,1))
		score_label.add_theme_constant_override("shadow_offset_x", 5)
		score_label.add_theme_constant_override("shadow_offset_y", 5)
		score_vbox.add_child(score_label)
	add_child(score_vbox)
"""
Syfte: Skapar kolumer för varje score, namn och position så att de sedan
	   kan dyka upp som en rad brevid varandra
"""
func sort_players_and_add_position(player_list):
	var position = 1
	
	for player in player_list:
		player["position"] = position
		position += 1
	
	return player_list
"""
Syfte: Sorterar alla scores så de dycker upp i rätt ordning
"""

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/General/start_menu.tscn")
	AudioController.play_button_sound()
"""
Syfte: Tar dig tillbaka till main menyn
"""
