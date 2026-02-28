extends Node2D

const ENEMY_BULLET = preload("res://Scenes/Enemies/enemy_bullet.tscn")
const ENEMY_FIRE_BULLET = preload("res://Scenes/Enemies/enemy_fire_bullet.tscn")

const BULLET_SCENE = preload("res://Scenes/Player_Attacks/bullet.tscn")
const MElEE_ATTACK_SCENE = preload("res://Scenes/Player_Attacks/melee_attack.tscn")
const ROCKET_SCENE = preload("res://Scenes/Player_Attacks/Rocket.tscn")
const GRENADE_SCENE = preload("res://Scenes/Player_Attacks/Grenade.tscn")

const ENEMY_INDICATOR_ARROW_SCENE = preload("res://Scenes/General/indicator_arrow.tscn")

@onready var player = $Player
@onready var pause_menu = $PauseMenuCanvas/PauseMenu
@onready var wave_manager = $WaveManager
@onready var inv = player.get_child(11).get_child(0)
@onready var death_menu = $DeathMenuCanvas/DeathMenu

var item_card = preload("res://Scenes/Inventory/item_card.tscn")

var wave: int = 1
var enemies_left: int 
var paused: bool = false

var slot_ready = [true, true, true, true, true, true]

func _ready() -> void:
	player.inventory.items[0] = PreloadItems.Sword
	inv.update_slots()
	for i in range(1, 6):
		player.inventory.items[i] = null
		inv.update_slots()
	player.connect("attack", attack)
	wave_manager.connect("wave_complete", wave_complete)
	wave_manager.start_game()

func _process(_delta: float) -> void:
	if Globals.player_lives <= 0 and !Globals.dead:
		deathMenu()
	enemies_left = get_tree().get_nodes_in_group("enemies").size()
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	$HUD/WaveNumber.text = str(wave)
	$HUD/VBoxContainer/EnemiesLeft.text = str(enemies_left)
	$HUD/VBoxContainer/Money.text = "$" + str(Globals.money)
	if enemies_left <= 5 and !wave_manager.spawning:
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if get_tree().get_nodes_in_group("arrows").size() < get_tree().get_nodes_in_group("enemies").size():
				enemy_arrow(enemy)
	calc_heal_number()
			
func enemy_arrow(enemy):
	var arrow = ENEMY_INDICATOR_ARROW_SCENE.instantiate()
	arrow.enemy = enemy 
	$HUD.add_child(arrow)

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

func deathMenu():
	death_menu.show()
	Engine.time_scale = 0

func wave_complete()->void:
	var item_card_1 = item_card.instantiate()
	item_card_1.card_1()
	item_card_1.position = Vector2(910, 430)
	$ShopHUD.add_child(item_card_1)
	
	var item_card_2 = item_card.instantiate()
	item_card_2.position = Vector2(1280, 430)
	$ShopHUD.add_child(item_card_2)
	item_card_2.card_2()
	
	var item_card_3 = item_card.instantiate()
	item_card_3.position = Vector2(1650, 430)
	item_card_3.card_3()
	$ShopHUD.add_child(item_card_3)
	$ShopHUD.visible = true
	await get_tree().create_timer(0.01).timeout
	if Globals.player_max_lives != Globals.player_lives and Globals.money >= 5:
		$ShopHUD/VBoxContainer/Heal.visible = true
	else:
		$ShopHUD/VBoxContainer/Heal.visible = false

func start_timer(i:int, timer:float):
	get_tree().create_timer(timer).timeout.connect(_on_timer_done.bind(i))

func _on_timer_done(i):
	slot_ready[i-1] = true

func attack()->void:
	var i:int = 0
	for item in player.inventory.items:
		i += 1
		if item != null and slot_ready[i-1]:
			slot_ready[i-1] = false
			start_timer(i, item.delay)
			if item.type == "gun":
				var bullet = BULLET_SCENE.instantiate()
				bullet.damage = item.damage
				bullet.speed = item.speed
				bullet.range = item.range
				bullet.global_position = player.get_child(i).global_position
				bullet.dir = player.get_local_mouse_position()
				add_child(bullet)
			if item.type == "melee":
				var sword = MElEE_ATTACK_SCENE.instantiate()
				var shape: RectangleShape2D = RectangleShape2D.new()
				var angle = get_angle_to(player.get_local_mouse_position())
				shape.size = Vector2(50*item.range, 25*item.range) 
				sword.get_child(0).get_child(0).shape = shape
				sword.range = item.range
				sword.position = player.position + Vector2.RIGHT.rotated(angle)*50
				sword.rotation = angle
				sword.damage = item.damage
				sword.get_child(2).texture = item.texture
				add_child(sword)
			if item.type == "rocket launcher":
				var rocket = ROCKET_SCENE.instantiate()
				var angle = get_angle_to(player.get_local_mouse_position())
				rocket.rotation = angle+PI/2
				rocket.range = item.range
				rocket.damage = item.damage
				rocket.global_position = player.get_child(i).global_position
				rocket.dir = player.get_local_mouse_position()
				add_child(rocket)
			if item.type == "grenade launcher":
				var grenade = GRENADE_SCENE.instantiate()
				var angle = get_angle_to(player.get_local_mouse_position())
				grenade.rotation = angle+PI/2
				grenade.range = item.range
				grenade.damage = item.damage
				grenade.global_position = player.get_child(i).global_position
				grenade.dir = player.get_local_mouse_position()
				add_child(grenade)
			
func _on_start_next_wave_pressed() -> void:
	$ShopHUD.visible = false
	for i in range($ShopHUD.get_child_count()):
		if $ShopHUD.get_child(i) is Node2D:
			$ShopHUD.get_child(i).queue_free()
		else:
			pass
	wave += 1
	wave_manager.start_wave()

func shoot_enemy_attack(dir, pos:Vector2, damage, speed):
	var enemy_bullet = ENEMY_BULLET.instantiate()
	enemy_bullet.speed = speed
	enemy_bullet.dir = dir
	enemy_bullet.position = Vector2(pos)
	enemy_bullet.damage = damage
	add_child(enemy_bullet)

func shoot_enemy_fire_attack(dir, pos:Vector2, damage, speed):
	var enemy_bullet = ENEMY_FIRE_BULLET.instantiate()
	enemy_bullet.speed = speed
	enemy_bullet.dir = dir
	enemy_bullet.position = Vector2(pos)
	var angle = get_angle_to(dir)
	enemy_bullet.rotation = angle
	enemy_bullet.damage = damage
	add_child(enemy_bullet)

func _on_heal_pressed() -> void:
	$ShopHUD/VBoxContainer/Heal.visible = false
	var missing_lives = Globals.player_max_lives - Globals.player_lives
	
	var max_heal = Globals.money / 5
	var healing = min(missing_lives, max_heal)
	
	Globals.player_lives += healing
	Globals.money -= healing * 5

func calc_heal_number():
	$ShopHUD/VBoxContainer/Heal/HBoxContainer/Label2.text = "$" + str(min(Globals.player_max_lives-Globals.player_lives, Globals.money/5) * 5)
