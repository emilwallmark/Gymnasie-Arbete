extends Node

var player_max_lives: int = 5
var player_lives:int = 5

var dead: bool = false

var money: int = 0



#Leaderboard Saker

var player_name: String
var player_list = []

var score = 0

func _ready() -> void:
	SilentWolf.configure({
		"api_key": "Knv7UhgEdL5jAo8hfrctv3C2Q757LEKn6c9pLgVu",
		"game_id":"desertsurvival",
		"log_level": 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn"
	})
"""
Syfte: Konfigurerar leaderboarden då spelet startar
"""
