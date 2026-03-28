extends Node

signal wave_complete

@onready var player = get_tree().get_first_node_in_group("Player")
@export var waves: Array[WaveData]
@export var endless_start_wave := 26

@export var enemy_scenes := {
 "enemy_1" : preload("res://Scenes/Enemies/enemy.tscn"),
 "enemy_2" : preload("res://Scenes/Enemies/enemy_2.tscn"), 
 "enemy_3" : preload("res://Scenes/Enemies/enemy_3.tscn"),
 "enemy_4" : preload("res://Scenes/Enemies/enemy_4.tscn"),
 "enemy_5" : preload("res://Scenes/Enemies/enemy_5.tscn"),
 "enemy_6" : preload("res://Scenes/Enemies/enemy_6.tscn"),
 "shoot_enemy_1" : preload("res://Scenes/Enemies/shoot_enemy.tscn"),
 "shoot_enemy_2" : preload("res://Scenes/Enemies/shoot_enemy_2.tscn"),
 "shoot_enemy_3" : preload("res://Scenes/Enemies/shoot_enemy_3.tscn"),
 "shoot_enemy_4" : preload("res://Scenes/Enemies/shoot_enemy_4.tscn"), 
 "sniper_enemy_1" : preload("res://Scenes/Enemies/sniper_enemy.tscn"),
 "kamikaze_enemy_1" : preload("res://Scenes/Enemies/kamikaze_enemy.tscn"),
 "summoner" : preload("res://Scenes/Enemies/summoner.tscn"),
 "fire_spirit" : preload("res://Scenes/Enemies/fire_spirit.tscn"),
 "splitter" : preload("res://Scenes/Enemies/splitter.tscn"),
 "splitter_baby" : preload("res://Scenes/Enemies/splitter_baby.tscn"),
 "Boss" : preload("res://Scenes/Boss/BOSS.tscn")
}

var enemy_cost := {
 "enemy_4" : 1,
 "enemy_5" : 3,
 "enemy_6" : 10,
 "shoot_enemy_3" : 5,
 "shoot_enemy_4" : 15, 
 "sniper_enemy_1" : 20,
 "kamikaze_enemy_1" : 8,
 "summoner" : 25,
 "splitter" : 13,
}

var current_wave := 0
var alive_enemies := 0
var spawning := false
var cheating = false
var temp_wave: int

var splitter_pos : Vector2 #för att ha positionen där splitter_baby ska spawna

func _ready() -> void:
	Cheats.cheatmode.connect(on_cheats)
"""
Syfte: Ta emot cheatmode signalen
"""

func on_cheats(wave):
	cheating = true
	temp_wave = wave
"""
Syfte: Sätta på cheatmode 
"""

func start_game():
	await get_tree().create_timer(0.4).timeout
	if cheating:
		current_wave = temp_wave
	else:
		current_wave = 0
	start_wave()
"""
Syfte: Sätta på spelet på rätt wave
"""

func start_wave():
	spawning = true
	var wave_data = get_wave_data(current_wave)
	await spawn_wave(wave_data)
	spawning = false
"""
Syfte: Köra waven som ska köras, först hämtar vilka fiender som ska spawna och sedan spawna in de fiender
"""
	
func get_wave_data(wave_index: int) -> WaveData:
	if wave_index < waves.size():
		return waves[wave_index]
	else:
		return generate_endless_wave(wave_index)
"""
Syfte: ger antingen wave data för den wave man valt eller kör en funktion som skapar wave data 
       så att fiender ska skapas
"""
	
func spawn_wave(wave: WaveData) -> void:
	for enemy_type in wave.enemies.keys():
		for i in wave.enemies[enemy_type]:
			spawn_enemy(enemy_type)
			await get_tree().create_timer(wave.spawn_delay).timeout
"""
Syfte: ta alla värden i wave datan och köra spawn_ennemy() på varje data punkt
"""

func get_spawn_position() -> Vector2:
	var world_bounds := Rect2(Vector2(-2000, -2300), Vector2(4100, 4800))
	var camera := player.get_child(0)
	var viewport_rect := get_viewport().get_visible_rect()
	var cam_center = camera.global_position

	var min_radius = max(viewport_rect.size.x, viewport_rect.size.y) * 0.6
	var max_radius = min_radius + 400

	for i in range(20): 
		var angle := randf() * TAU
		var radius := randf_range(min_radius, max_radius)
		var dir := Vector2(cos(angle), sin(angle))

		var pos = cam_center + dir * radius

		if not world_bounds.has_point(pos):
			continue
		if !viewport_rect.has_point(pos):
			continue

		return pos
	return get_farthest_world_corner(cam_center)
"""
Syfte: Få spawn positioner som är på kartan men inte i kameran så man inte kan se då fienderna spawar in
	   och om den inte hittar något letar den efter hörnet längst bort från spelaren
"""
func get_farthest_world_corner(from_pos: Vector2) -> Vector2:
	var world_bounds := Rect2(Vector2(-2000, -2300), Vector2(4100, 4800))
	var corners := [
		world_bounds.position,
		world_bounds.position + Vector2(world_bounds.size.x, 0),
		world_bounds.position + Vector2(0, world_bounds.size.y),
		world_bounds.position + world_bounds.size
	]
	var best = corners[0]
	var best_dist := -INF

	for c in corners:
		var d = c.distance_squared_to(from_pos)
		if d > best_dist:
			best_dist = d
			best = c
	return best
"""
Syfte: Om fieden inte hittar någonstans att spawna på så hittar den det bästa hörnet att spawna på
"""
func random_outside_center() -> int:
	if randi() % 2 == 0:
		return randi_range(-300, -150)
	else:
		return randi_range(150, 300)
"""
Syfte: Då summoner spawnar in sina "barn" så är dethär poitionen från spelaren de ska spawna in på
       och då splitter dör spawnar de på den positionen från där den dog
"""

func spawn_enemy(enemy_type: String) -> void:
	if enemy_type != "fire_spirit" and enemy_type != "splitter_baby":
		var enemy_scene = enemy_scenes.get(enemy_type)
		if enemy_scene == null:
			push_error("Unknown enemy type: " + enemy_type) #Chat GPT aah kod
			return

		var enemy = enemy_scene.instantiate()
		enemy.global_position = get_spawn_position()
		enemy.player = player

		add_child(enemy)
		alive_enemies += 1
		enemy.died.connect(_on_enemy_died)
	elif enemy_type == "fire_spirit":
		var enemy_scene = enemy_scenes.get(enemy_type)

		var enemy = enemy_scene.instantiate()
		var x = random_outside_center()
		var y = random_outside_center()
		enemy.global_position = player.global_position + Vector2(x, y)
		enemy.player = player

		add_child(enemy)
		alive_enemies += 1
		enemy.died.connect(_on_enemy_died)
	
	elif enemy_type == "splitter_baby":
		for i in range(3):
			var enemy_scene = enemy_scenes.get(enemy_type)

			var enemy = enemy_scene.instantiate()
			var x = random_outside_center()
			var y = random_outside_center()
			enemy.global_position = splitter_pos + Vector2(x, y)
			enemy.player = player

			add_child(enemy)
			alive_enemies += 1
			enemy.died.connect(_on_enemy_died)
"""
Syfte: Spawna in alla fiender på kartan
"""
	
func _on_enemy_died():
	alive_enemies -= 1

	if alive_enemies <= 0 and !spawning:
		await end_wave()
"""
Syfte: Sänka mängden levande fiender och kolla om alla är döda
"""

func end_wave():
	current_wave += 1
	emit_signal("wave_complete")
"""
Syfte: Avsluta waves, skickar signal till level som säger att waven är avklarad
"""
	
func generate_endless_wave(wave: int):
	var budget := get_wave_budget(wave)
	var enemy_dict := {}

	while budget > 0:
		var possible_enemies := []
		for enemy in enemy_cost.keys():
			if enemy_cost[enemy] <= budget:
				possible_enemies.append(enemy)
		if possible_enemies.is_empty():
			break
		var chosen = possible_enemies.pick_random()
		enemy_dict[chosen] = enemy_dict.get(chosen, 0) + 1
		budget -= enemy_cost[chosen]

	var wave_data := WaveData.new()
	wave_data.enemies = enemy_dict
	wave_data.spawn_delay = get_spawn_delay(wave)
	return wave_data
"""
Syfte: Generera oändligt med waves efter att man klarat alla vanliga waves
"""

func get_spawn_delay(wave: int) -> float:
	var difficulty := wave - 25
	return max(0.05, 0.25 - difficulty * 0.002)
"""
Syfte: Gör att fiederna spawnar in snabbare och snabbare efter wave 25
"""

func get_wave_budget(wave_index: int) -> int:
	var difficulty = wave_index - 25
	return 200 + difficulty * 20
"""
Syfte: Gör att waves blir svårare och svårare ju mer man klarar efter wave 25
"""
