extends Node2D


const ENEMY_SCENE = preload("res://Scenes/enemy.tscn")
const BULLET_SCENE = preload("res://Scenes/bullet.tscn")


@onready var player = $Player

var test_item = preload("res://Inventory/Items/Basic Gun.tres")

var wave: int = 1
var enemys_left: int 
var enemys_spawned: int
var wave_cap: int
var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("attack", attack)
	waves()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemys_left = get_tree().get_nodes_in_group("enemys").size()
	if Input.is_action_just_pressed("End") and not paused:
		Engine.time_scale = 0
		paused = true
		#get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	elif Input.is_action_just_pressed("End") and paused:
		Engine.time_scale = 1
		paused = false
	$HUD/WaveNumber.text = str(wave)
	$HUD/EnemysLeft.text = str(enemys_left)
	if enemys_left == 0 and enemys_spawned == wave_cap:
		wave_complete()
		
func waves()->void:
	if wave == 1:
		wave_cap = 2
		for n in range(wave_cap):
			await get_tree().create_timer(0.7).timeout
			spawn_enemy()
		if enemys_left == 0 and enemys_spawned == 20:
			wave += 1
	elif wave == 2:
		wave_cap = 30
		for n in range(wave_cap):
			await get_tree().create_timer(0.3).timeout
			spawn_enemy()

func wave_complete()->void:
	enemys_spawned = 0
	$ShopHUD.visible = true


func attack()->void:
	var i:int = 0
	for item in player.inventory.items:
		i += 1
		if item != null:
			if item.type == "gun":
				var bullet = BULLET_SCENE.instantiate()
				bullet.damage = item.damage
				bullet.global_position = player.get_child(i+1).global_position
				bullet.dir = player.get_local_mouse_position()
				add_child(bullet)
				

func spawn_enemy() -> void:
	var enemyX = randi_range(100,1000)
	var enemyY = randi_range(50,500)
	var enemy = ENEMY_SCENE.instantiate()
	enemy.global_position = Vector2(enemyX, enemyY)
	enemy.player = player
	add_child(enemy) # Replace with function body.
	enemys_spawned += 1


func _on_start_next_wave_pressed() -> void:
	$ShopHUD.visible = false
	wave += 1
	waves() # Replace with function body.


func _on_add_gun_pressed() -> void:
	var done = false
	var  x= 0
	while not done:
		if x == 6:
			done = true
			
		elif player.inventory.items[x] == null:
			player.inventory.items.pop_at(x)
			player.inventory.items.insert(x, test_item) 
			$ShopHUD/Inv_UI.update_slots()
			done = true
		else:
			x += 1
