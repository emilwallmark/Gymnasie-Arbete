extends Node2D

const ENEMY_BULLET = preload("res://Scenes/Enemies/enemy_bullet.tscn")

const BULLET_SCENE = preload("res://Scenes/Player_Attacks/bullet.tscn")
const MElEE_ATTACK_SCENE = preload("res://Scenes/Player_Attacks/melee_attack.tscn")

@onready var player = $Player
@onready var pause_menu = $PauseMenuCanvas/PauseMenu
@onready var wave_manager = $WaveManager

var item_card = preload("res://Scenes/Inventory/item_card.tscn")

var wave: int = 1
var enemys_left: int 
var enemys_spawned: int
var wave_cap: int
var paused: bool = false

func _ready() -> void:
	player.connect("attack", attack)
	wave_manager.connect("wave_complete", wave_complete)
	wave_manager.start_game()


func _process(_delta: float) -> void:
	enemys_left = get_tree().get_nodes_in_group("enemies").size()
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	$HUD/WaveNumber.text = str(wave)
	$HUD/EnemysLeft.text = str(enemys_left)


func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

func wave_complete()->void:
	enemys_spawned = 0
	var item_card_1 = item_card.instantiate()
	item_card_1.card_1()
	item_card_1.position = Vector2(333, 326)
	$ShopHUD.add_child(item_card_1)
	
	var item_card_2 = item_card.instantiate()
	item_card_2.position = Vector2(689, 326)
	$ShopHUD.add_child(item_card_2)
	item_card_2.card_2()
	
	var item_card_3 = item_card.instantiate()
	item_card_3.position = Vector2(1064, 326)
	item_card_3.card_3()
	$ShopHUD.add_child(item_card_3)
	$ShopHUD.visible = true
	

func attack()->void:
	var i:int = 0
	for item in player.inventory.items:
		i += 1
		if item != null:
			if item.type == "gun":
				var bullet = BULLET_SCENE.instantiate()
				bullet.damage = item.damage
				bullet.global_position = player.get_child(i).global_position
				bullet.dir = player.get_local_mouse_position()
				add_child(bullet)
			if item.type == "melee":
				var attack = MElEE_ATTACK_SCENE.instantiate()
				var shape: RectangleShape2D = RectangleShape2D.new()
				var angle = get_angle_to(player.get_local_mouse_position())
				shape.size = Vector2(100, 67) 
				attack.get_child(0).get_child(0).shape = shape
				attack.position = player.position + Vector2.RIGHT.rotated(angle)*50
				attack.rotation = angle
				attack.damage = item.damage
				attack.get_child(2).texture = item.texture
				add_child(attack)
			
func _on_start_next_wave_pressed() -> void:
	$ShopHUD.visible = false
	if $ShopHUD.get_child(7) != null:
		$ShopHUD.get_child(7).queue_free()
	if $ShopHUD.get_child(8) != null:
		$ShopHUD.get_child(8).queue_free()
	if $ShopHUD.get_child(9) != null:
		$ShopHUD.get_child(9).queue_free()
	else:
		pass
	wave += 1
	wave_manager.start_wave()


@onready var inv = player.get_child(11).get_child(0)
func _on_button_1_pressed() -> void:
	player.inventory.items[0] = null
	inv.update_slots()

func _on_button_2_pressed() -> void:
	player.inventory.items[1] = null
	player.get_child(11).get_child(0).update_slots()

func _on_button_3_pressed() -> void:
	player.inventory.items[2] = null
	player.get_child(11).get_child(0).update_slots()

func _on_button_4_pressed() -> void:
	player.inventory.items[3] = null
	player.get_child(11).get_child(0).update_slots()

func _on_button_5_pressed() -> void:
	player.inventory.items[4] = null
	player.get_child(11).get_child(0).update_slots()

func _on_button_6_pressed() -> void:
	player.inventory.items[5] = null
	player.get_child(11).get_child(0).update_slots()
	
func shoot_enemy_attack(dir, position:Vector2, damage, speed):
	var enemy_bullet = ENEMY_BULLET.instantiate()
	enemy_bullet.speed = speed
	enemy_bullet.dir = dir
	enemy_bullet.position = Vector2(position)
	enemy_bullet.damage = damage
	add_child(enemy_bullet)
