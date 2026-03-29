extends CharacterBody2D

signal died


const MAX_SPEED := 250
const ACC := 1500
const attack_speed = 500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Sprite2D
#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int
var max_lives: float = 5
var damage: int = 2
var distance_to_player 
var dead = false
var time_scale = 1

var shoot_timer = 0.0
var shoot_interval = 1.0

func _ready() -> void:
	lives = max_lives
"""
Syfte: Ge fieden rätt liv då den skapas
"""
func _process(_delta: float) -> void:
	health_bar.value = lives/max_lives * 100
	if lives <= 0 and !dead:
		dead = true
		await get_tree().create_timer(0.2).timeout
		die()
	if velocity.x < 0:
		enemy_texture.flip_h = true
	elif velocity.x > 0:
		enemy_texture.flip_h = false
	if velocity.x != 0 or velocity.y != 0:
		anim.play("Enemy_Walk")
	else:
		pass
		anim.play("Idle")
	if global_position.x > 4900 or global_position.x < -2400 or global_position.y > 4200 or global_position.y < -2400: 
		velocity = Vector2(0,0)
		global_position  = Vector2(0,0)
	anim.speed_scale = time_scale
"""
Syfte: Updartera allt som behöver updateras varje frame utom rörelse och om den ska skuta
"""
func _physics_process(delta: float) -> void:
	if player:
		var scaled_delta = delta * time_scale
		var direction_to_player = global_position.direction_to(player.global_position)
		distance_to_player = sqrt((global_position.x-player.global_position.x)**2 + (global_position.y - player.global_position.y)**2)
		if distance_to_player > 600:
			velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*scaled_delta)
			shoot_timer = 0.0
		else: 
			velocity = Vector2(0,0)
			shoot_timer += scaled_delta
			if shoot_timer >= shoot_interval:
				shoot_timer = 0.0
				get_parent().get_parent().shoot_enemy_attack(global_position.direction_to(player.global_position), position, damage, attack_speed)
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
	Globals.money += 1
	queue_free()
"""
Syfte: Ta bort fienden då den dör och ge pengar + skicka dödssignal till wave_manager()
"""
