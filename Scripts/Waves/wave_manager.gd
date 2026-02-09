extends Node

signal wave_complete

@onready var player = get_tree().get_first_node_in_group("Player")

@export var waves: Array[WaveData]
@export var endless_start_wave := 50

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
 "sniper_enemy_1" : preload("res://Scenes/Enemies/sniper_enemy.tscn"),
 "kamikaze_enemy_1" : preload("res://Scenes/Enemies/kamikaze_enemy.tscn")
}


var current_wave := 0
var alive_enemies := 0
var spawning := false

func start_game():
	print(player)
	current_wave = 0
	start_wave()
	
func start_wave():
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
	var world_bounds := Rect2(
	Vector2(-2000, -2300),
	Vector2(4100, 4800))
	var camera := player.get_child(0)
	var viewport_size := get_viewport().get_visible_rect().size
	var cam_center = camera.global_position

	var radius = max(viewport_size.x, viewport_size.y) * 0.6
	var angle := randf() * TAU
	var pos = cam_center + Vector2(cos(angle), sin(angle)) * radius

	pos.x = clamp(pos.x, world_bounds.position.x,
		world_bounds.position.x + world_bounds.size.x)

	pos.y = clamp(pos.y, world_bounds.position.y,
		world_bounds.position.y + world_bounds.size.y)
		
	return pos

func spawn_enemy(enemy_type: String) -> void:
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
	
func _on_enemy_died():
	alive_enemies -= 1

	if alive_enemies <= 0 and not spawning:
		await end_wave()

func end_wave():
	var wave_data := get_wave_data(current_wave)
	current_wave += 1
	emit_signal("wave_complete")
	
	
