extends Node2D

const ENEMY_BULLET = preload("res://Scenes/Enemies/enemy_bullet.tscn")
const ENEMY_FIRE_BULLET = preload("res://Scenes/Enemies/enemy_fire_bullet.tscn")

const BULLET_SCENE = preload("res://Scenes/Player_Attacks/bullet.tscn")
const MElEE_ATTACK_SCENE = preload("res://Scenes/Player_Attacks/melee_attack.tscn")
const ROCKET_SCENE = preload("res://Scenes/Player_Attacks/Rocket.tscn")
const GRENADE_SCENE = preload("res://Scenes/Player_Attacks/Grenade.tscn")

const ENEMY_INDICATOR_ARROW_SCENE = preload("res://Scenes/General/indicator_arrow.tscn")

var ITEM_CARD_SCENE = preload("res://Scenes/Inventory/item_card.tscn")

@onready var player = $Player
@onready var pause_menu = $PauseMenuCanvas/PauseMenu
@onready var wave_manager = $WaveManager
@onready var inv = player.get_node("InvCanvasLayer").get_child(0)
@onready var death_menu = $DeathMenuCanvas/DeathMenu
@onready var enemies_left: int 

var damage_boost = false
var multishot = false

var wave: int = 1
var paused: bool = false

var slot_ready = [true, true, true, true, true, true]

func _ready() -> void:
	Cheats.cheatmode.connect(_on_cheats)
	player.inventory.items[0] = PreloadItems.Sword
	inv.update_slots()
	for i in range(1, 6):
		player.inventory.items[i] = null
		inv.update_slots()
	player.connect("attack", attack)
	wave_manager.connect("wave_complete", wave_complete)
	wave_manager.start_game()

"""
Syfte: Updaterar alltd då spelet börjar
Kommentar: Ger spelaren rätt vapen, startar wavesen i wave_manager och tar
		   även emot signaler då spelaren attackerar och då en wave är avklarad
"""

func _on_cheats(wave1):
	wave += wave1
	player.inventory.items[0] = PreloadItems.Blaster
	player.inventory.items[1] = PreloadItems.Rocket_Launcher
	player.inventory.items[2] = PreloadItems.Rocket_Launcher
	player.inventory.items[3] = PreloadItems.Mega_Axe
	player.inventory.items[4] = PreloadItems.Blaster
	player.inventory.items[5] = PreloadItems.Blaster
	inv.update_slots()
"""
Syfte: ge spelaren vapen då fusk är på och att wave numret ska visa rätt då man fuskar
"""

func _process(_delta: float) -> void:
	if Globals.player_lives <= 0 and !Globals.dead:
		deathMenu()
	enemies_left = get_tree().get_nodes_in_group("enemies").size()
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	$HUD/WaveNumber.text = str(wave)
	$HUD/VBoxContainer/EnemiesLeft.text = str(enemies_left)
	$HUD/VBoxContainer/Money.text = "$" + str(Globals.money)
	find_enemy_arrow()
	
"""
Syfte: Uppdatera allt som ska updateeras varje frame
Kommentar: Kollar om spelaren är död, kollar hur många fiedenr som är kvar, updaterar HUD
		   uppdaterar find_enemy_arrow() och calc_heal_number()
"""

func find_enemy_arrow():
	if enemies_left <= 5 and !wave_manager.spawning:
		var enemies = get_tree().get_nodes_in_group("enemies")
		var arrows = get_tree().get_nodes_in_group("arrows")
		for enemy in enemies:
			var has_arrow = false
			for arrow in arrows:
				if arrow.enemy == enemy:
					has_arrow = true
					break
			if !has_arrow:
				enemy_arrow(enemy)
"""
Syfte: Veta vilka fiender som ska få en pil mot sig
"""

func enemy_arrow(enemy):
	var arrow = ENEMY_INDICATOR_ARROW_SCENE.instantiate()
	arrow.enemy = enemy 
	$HUD.add_child(arrow)
"""
Syfte: Sätta ut pilen på fienden
Parameter: enemy: fienden som får pilen på sig
"""

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
"""
Syfte: Pausa spelet och visa pausemeny
	   Även stänga gömma pausemany och återupta spelet
"""

func deathMenu():
	death_menu.show()
	Engine.time_scale = 0

"""
Syfte: Pausa spelet då man är död och visa dödsmenyn
"""

func wave_complete()->void:
	var item_card_1 = ITEM_CARD_SCENE.instantiate()
	item_card_1.card_1()
	item_card_1.position = Vector2(910, 430)
	$ShopHUD.add_child(item_card_1)
	
	var item_card_2 = ITEM_CARD_SCENE.instantiate()
	item_card_2.position = Vector2(1280, 430)
	$ShopHUD.add_child(item_card_2)
	item_card_2.card_2()
	
	var item_card_3 = ITEM_CARD_SCENE.instantiate()
	item_card_3.position = Vector2(1650, 430)
	item_card_3.card_3()
	$ShopHUD.add_child(item_card_3)
	$ShopHUD.visible = true
	await get_tree().create_timer(0.01).timeout
	if Globals.player_max_lives != Globals.player_lives and Globals.money >= 5:
		calc_heal_number()
		$ShopHUD/VBoxContainer/Heal.visible = true
	else:
		$ShopHUD/VBoxContainer/Heal.visible = false
"""
Syfte: Visa Shopmenyn då en wave är klar
Kommentar: Visar alla cards, kör olika funktioner i item_card beroende på vilket kort det är
		   visar healknappen om man tagit skada
"""

func start_timer(i:int, timer:float):
	get_tree().create_timer(timer).timeout.connect(_on_timer_done.bind(i))
"""
Syfte: Startar en timer som ska göra att man inte kan spam attackera alla vapen
Parametrar: i: index för vilket vapen som timern sker på
            timer: hur länge timern ska vara, kommer från delay parametern i varje vapen
"""

func _on_timer_done(i):
	slot_ready[i-1] = true
"""
Syfte: Då timern är klar så ska den göra det tillåtet för ett vapen att atackera igen
Parametrar: i: index för vilket vapen som ska få attackera igen
"""

func attack()->void:
	var i:int = 0
	for item in player.inventory.items:
		i += 1
		if item != null and slot_ready[i-1]:
			slot_ready[i-1] = false
			start_timer(i, item.delay)
			if item.type == "gun":
				if item.name == "Basic Gun" or item.name == "Revolver" or item.name == "SMG":
					AudioController.play_gun_sound()
				elif item.name == "AK" or item.name == "Shotgun":
					AudioController.play_heavy_gun_sound()
				elif item.name == "Blaster":
					AudioController.play_blaster_sound()
				elif item.name == "Sniper" or item.name == "Heavy Sniper":
					AudioController.play_sniper_sound()
				var bullet = BULLET_SCENE.instantiate()
				if !damage_boost:
					bullet.damage = item.damage
				else:
					bullet.damage = int(item.damage * 1.5)
				bullet.multishot = multishot
				bullet.speed = item.speed
				bullet.range = item.range
				bullet.global_position = player.get_child(i).global_position
				bullet.dir = player.get_local_mouse_position()
				add_child(bullet)
			if item.type == "melee":
				AudioController.play_sword_sound()
				var sword = MElEE_ATTACK_SCENE.instantiate()
				var shape: RectangleShape2D = RectangleShape2D.new()
				var angle = get_angle_to(player.get_local_mouse_position())
				shape.size = Vector2(50*item.range, 25*item.range) 
				sword.get_child(0).get_child(0).shape = shape
				sword.range = item.range
				sword.position = player.position + Vector2.RIGHT.rotated(angle)*50
				sword.rotation = angle
				if !damage_boost:
					sword.damage = item.damage
				else:
					sword.damage = int(item.damage * 1.5)
				sword.multishot = multishot
				sword.get_child(2).texture = item.texture
				add_child(sword)
			if item.type == "rocket launcher":
				AudioController.play_rocket_launcher_sound()
				var rocket = ROCKET_SCENE.instantiate()
				var angle = get_angle_to(player.get_local_mouse_position())
				rocket.rotation = angle+PI/2
				rocket.range = item.range
				if !damage_boost:
					rocket.damage = item.damage
				else:
					rocket.damage = int(item.damage * 1.5)
				rocket.global_position = player.get_child(i).global_position
				rocket.dir = player.get_local_mouse_position()
				rocket.multishot = multishot
				add_child(rocket)
			if item.type == "grenade launcher":
				AudioController.play_gun_sound()
				var grenade = GRENADE_SCENE.instantiate()
				var angle = get_angle_to(player.get_local_mouse_position())
				grenade.rotation = angle+PI/2
				grenade.range = item.range
				if !damage_boost:
					grenade.damage = item.damage
				else:
					grenade.damage = int(item.damage * 1.5)
				grenade.multishot = multishot
				grenade.global_position = player.get_child(i).global_position
				grenade.dir = player.get_local_mouse_position()
				add_child(grenade)
"""
Syfte: Körs varje gång spelaren attackerar och utför attacken
Kommentar: Körs här och inte i spelarscritpen för att attackerna inte ska fastna i 
		   spelaren och följa med den vart den går.
		   Körs från signalen attack
"""

func _on_start_next_wave_pressed() -> void:
	AudioController.play_button_sound()
	$ShopHUD.visible = false
	for i in range($ShopHUD.get_child_count()):
		if $ShopHUD.get_child(i) is Node2D:
			$ShopHUD.get_child(i).queue_free()
		else:
			pass
	wave += 1
	wave_manager.start_wave()
"""
Syfte: Starta nästa wave då spelaren är redo
Kommentar: Kör då spelaren trycker på en knapp
"""

func shoot_enemy_attack(dir, pos:Vector2, damage, speed):
	var enemy_bullet = ENEMY_BULLET.instantiate()
	enemy_bullet.speed = speed
	enemy_bullet.dir = dir
	enemy_bullet.position = Vector2(pos)
	enemy_bullet.damage = damage
	add_child(enemy_bullet)
"""
Syfte: Spawnar in fiende skott så bestämer deras parametrar
Parametrar: dir: Riktningen till spelaren
			pos: positionen där skottet ska börja på
			damage: hur mycket skada skottet ska göra om den träffar spelaren
			speed: hastigheten skottet ska röra sig 
"""

func shoot_enemy_fire_attack(dir, pos:Vector2, damage, speed):
	var enemy_bullet = ENEMY_FIRE_BULLET.instantiate()
	enemy_bullet.speed = speed
	enemy_bullet.dir = dir
	enemy_bullet.position = Vector2(pos)
	var angle = get_angle_to(dir)
	enemy_bullet.rotation = angle
	enemy_bullet.damage = damage
	add_child(enemy_bullet)
"""
Samma som shoot_enemy_attack() men skapar ett skott med en annan textur
och den räknar ut vinkeln texturen ska roteras med
"""

func _on_ability_shop_pressed() -> void:
	$AbilityShop.show()
	$ShopHUD.hide()
	AudioController.play_button_sound()
"""
Syfte: Visa ability shop
"""

func _on_back_pressed() -> void:
	$AbilityShop.hide()
	$ShopHUD.show()
	AudioController.play_button_sound()
"""
Syfte: Gå tillbaka till vanliga shoppen
"""

func _on_heal_pressed() -> void:
	AudioController.play_buy_sound()
	$ShopHUD/VBoxContainer/Heal.visible = false
	var missing_lives = Globals.player_max_lives - Globals.player_lives
	
	var max_heal = Globals.money / ceili(float(wave)/3)
	var healing = min(missing_lives, max_heal)
	
	Globals.player_lives += healing
	Globals.money -= healing * ceili(float(wave)/3)
"""
Syfte: Öka spelarens hp då knapped Heal är tryckt
"""

func calc_heal_number():
	$ShopHUD/VBoxContainer/Heal/HBoxContainer/Label2.text = "$" + str(min(Globals.player_max_lives-Globals.player_lives, Globals.money) * ceili(float(wave)/3))
"""
Syfte: Räkna ut hur mycket pengar som ska visas på labeln på knappen som visar hur mycket 
	   pengar som man kommer tappa
"""


func _on_invinvibility_pressed() -> void:
	if Globals.money >= 300:
		Globals.money -= 300
		AudioController.play_buy_sound()
		player.invinibility = true
		player.invincibility_bar.show()
		$AbilityShop/InvincibilityCard.hide()
		$AbilityShop/Invinvibility.hide()
		$AbilityShop/InvinsLabel.hide()
		$AbilityShop/InvinsPic.hide()
		$AbilityShop/InvinsCostLabel.hide()
	else:
		AudioController.play_error_sound()
"""
Syfte: Ge spelaren en invinsibility då den köper den
"""


func _on_movement_speed_pressed() -> void:
	if Globals.money >= 500:
		Globals.money -= 500
		AudioController.play_buy_sound()
		player.speed = 400
		$AbilityShop/MovementSpeedCard.hide()
		$AbilityShop/MovementSpeedPic.hide()
		$AbilityShop/MovementSpeedLabel.hide()
		$AbilityShop/MovementSpeedCostLabel.hide()
		$AbilityShop/MovementSpeed.hide()
	else:
		AudioController.play_error_sound()
"""
Syfte: Ge spelaren en speed upgrade då den köper den
"""


func _on_damage_boost_pressed() -> void:
	if Globals.money >= 700:
		Globals.money -= 700
		AudioController.play_buy_sound()
		damage_boost = true
		player.damage_boost = true
		$AbilityShop/DamageBoostCard.hide()
		$AbilityShop/DamageBoostPic.hide()
		$AbilityShop/DamageBoostLabel.hide()
		$AbilityShop/DamageBoostCostLabel.hide()
		$AbilityShop/DamageBoost.hide()
	else:
		AudioController.play_error_sound()
"""
Syfte: Ge spelaren en damage boost då den köper den
"""


func _on_slow_down_pressed() -> void:
	if Globals.money >= 350:
		Globals.money -= 350
		AudioController.play_buy_sound()
		$AbilityShop/SlowDownTimeCard.hide()
		$AbilityShop/SlowDownPic.hide()
		$AbilityShop/SlowDownLabel.hide()
		$AbilityShop/SlowDownCostLabel.hide()
		$AbilityShop/SlowDown.hide()
		player.can_slow_down_time = true
		player.slow_down_time_bar.show()
	else:
		AudioController.play_error_sound()
"""
Syfte: Ge spelaren slowdown time abilityn
"""


func _on_dash_pressed() -> void:
	if Globals.money >= 250:
		Globals.money -= 250
		AudioController.play_buy_sound()
		player.can_dash = true
		player.dash_bar.show()
		$AbilityShop/DashCard.hide()
		$AbilityShop/DashPic.hide()
		$AbilityShop/DashLabel.hide()
		$AbilityShop/DashCostLabel.hide()
		$AbilityShop/Dash.hide()
	else:
		AudioController.play_error_sound()
"""
Syfte: Ge spelaren dash abilityn
"""


func _on_multishot_pressed() -> void:
	if Globals.money >= 900:
		Globals.money -= 900
		AudioController.play_buy_sound()
		multishot = true
		$AbilityShop/MultishotCard.hide()
		$AbilityShop/MultishotLabel.hide()
		$AbilityShop/MultishotCostLabel.hide()
		$AbilityShop/MultishotPic1.hide()
		$AbilityShop/MultishotPic2.hide()
		$AbilityShop/MultishotPic3.hide()
		$AbilityShop/Multishot.hide()
	else:
		AudioController.play_error_sound()
"""
Syfte: Ge spelaren multishot abilityn
"""
