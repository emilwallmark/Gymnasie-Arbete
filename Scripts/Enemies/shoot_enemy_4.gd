extends CharacterBody2D

signal died

const MAX_SPEED := 50
const ACC := 1500
const attack_speed = 500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Walk
@onready var enemy_texture2: Sprite2D = $Attack

#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int
var max_lives: float = 30
var damage: int = 12
var distance_to_player 
var dead = false
var time_scale = 1

var shoot_timer = 0.0
var shoot_interval = 3.0

func _ready() -> void:
	anim.play("Walk")
	enemy_texture2.hide()
	lives = max_lives
"""
Syfte:Starta fiende animation och ge den rätt hp
"""
func _process(_delta: float) -> void:
	health_bar.value = lives/max_lives * 100
	if lives <= 0 and !dead:
		dead = true
		await get_tree().create_timer(0.2).timeout
		die()
	if velocity.x < 0:
		enemy_texture.flip_h = true
		enemy_texture2.flip_h = true
	elif velocity.x > 0:
		enemy_texture.flip_h = false
		enemy_texture2.flip_h = false
	if global_position.x > 4900 or global_position.x < -2400 or global_position.y > 4200 or global_position.y < -2400: 
		velocity = Vector2(0,0)
		global_position  = Vector2(0,0)
	anim.speed_scale = time_scale
"""
Syfte: Updartera allt som behöver updateras varje frame utom rörelse
"""
func _physics_process(delta: float) -> void:
	if player:
		var scaled_delta = delta * time_scale
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*scaled_delta)
		if velocity > direction_to_player*MAX_SPEED:
			velocity = direction_to_player*MAX_SPEED
		if shoot_timer >= shoot_interval:
			shoot_timer = 0.0
			enemy_texture2.show()
			enemy_texture.hide()
			anim.play("Attack")
			await anim.animation_finished
			get_parent().get_parent().shoot_enemy_fire_attack(global_position.direction_to(player.global_position), position, damage, attack_speed)
			anim.play("Walk")
			enemy_texture.show()
			enemy_texture2.hide()
		velocity *= time_scale
		move_and_slide()
"""
Syfte: Få fienden att gå mot spelaren varje frame och skuta då den ska skuta
"""
func on_take_dmg():
	var original_color = self_modulate
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	if lives > 0:
		modulate = original_color
"""
Syfte: Få fienden att blinka rött då den tar skada
"""
func die():
	died.emit()
	Globals.money += 3
	queue_free()
"""
Syfte: Ta bort fienden då den dör och ge pengar + skicka dödssignal till wave_manager()
"""

func _on_timer_timeout() -> void:
	enemy_texture2.show()
	enemy_texture.hide()
	anim.play("Attack")
	await anim.animation_finished
	get_parent().get_parent().shoot_enemy_fire_attack(global_position.direction_to(player.global_position), position, damage, attack_speed)
	anim.play("Walk")
	enemy_texture.show()
	enemy_texture2.hide()
"""
Syfte: Fienden ska skuta sitt skott mot spelaren då timern tar slut och den kör en animation
"""
