extends Node

signal wave_complete

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var temp_vic_screen = $"../DeathMenuCanvas/TempVictoryMenu"

@export var waves: Array[WaveData]
@export var endless_start_wave := 200

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
 "kamikaze_enemy_1" : preload("res://Scenes/Enemies/kamikaze_enemy.tscn")
}


var current_wave := 0
var alive_enemies := 0
var spawning := false



func start_game():
	current_wave = 21
	start_wave()
	
func start_wave():
	if current_wave ==endless_start_wave:
		generate_endless_wave()
	spawning = true
	var wave_data = get_wave_data(current_wave)
	await spawn_wave(wave_data)
	spawning = false
	
func get_wave_data(wave_index: int) -> WaveData:
	if wave_index < waves.size():
		return waves[wave_index]
	else:
		return
		#return generate_endless_wave(wave_index)
		
func spawn_wave(wave: WaveData) -> void:
	for enemy_type in wave.enemies.keys():
		for i in wave.enemies[enemy_type]:
			spawn_enemy(enemy_type)
			await get_tree().create_timer(wave.spawn_delay).timeout
			
func get_spawn_position() -> Vector2:
	var world_bounds := Rect2(Vector2(-2000, -2300), Vector2(4100, 4800))
	var camera := player.get_child(0)
	var viewport_rect := get_viewport().get_visible_rect()
	var cam_center = camera.global_position

	var min_radius = max(viewport_rect.size.x, viewport_rect.size.y) * 0.6
	var max_radius = min_radius + 400

	for i in range(20): # capped retries
		var angle := randf() * TAU
		var radius := randf_range(min_radius, max_radius)
		var dir := Vector2(cos(angle), sin(angle))

		var pos = cam_center + dir * radius

		# Rule 1: inside world bounds
		if not world_bounds.has_point(pos):
			continue

		# Rule 2: off-screen
		if !viewport_rect.has_point(pos):
			continue

		return pos
	return get_farthest_world_corner(cam_center)
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

func spawn_enemy(enemy_type: String) -> void:
	var enemy_scene = enemy_scenes.get(enemy_type)
	if enemy_scene == null:
		print("uhh")
		push_error("Unknown enemy type: " + enemy_type) #Chat GPT aah kod
		return

	var enemy = enemy_scene.instantiate()
	enemy.global_position = get_spawn_position()
	enemy.player = player

	add_child(enemy)
	alive_enemies += 1
	enemy.died.connect(_on_enemy_died)
	
func _on_enemy_died():
	alive_enemies -= 1

	if alive_enemies <= 0 and !spawning:
		await end_wave()

func end_wave():
	current_wave += 1
	emit_signal("wave_complete")
	
func generate_endless_wave():
	temp_vic_screen.show()
	Engine.time_scale = 0
