extends CharacterBody2D

signal died

const MAX_SPEED := 300
const ACC := 1500
const attack_speed = 500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Sprite2D
#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int
var max_lives: float = 10
var damage: int = 3
var distance_to_player 
var dead = false

func _ready() -> void:
	anim.play("Enemy_Walk")
	lives = max_lives


func _process(_delta: float) -> void:
	health_bar.value = lives/max_lives * 100
	if lives <= 0 and !dead:
		dead = true
		await get_tree().create_timer(0.2).timeout
		die()
	if velocity.x < 0:
		enemy_texture.flip_h = false
	elif velocity.x > 0:
		enemy_texture.flip_h = true


func _physics_process(delta: float) -> void:
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		distance_to_player = sqrt((global_position.x-player.global_position.x)**2 + (global_position.y - player.global_position.y)**2)
		if distance_to_player > 600:
			velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*delta)
			$Timer.stop()
		else: 
			velocity = Vector2(0,0)
			if $Timer.is_stopped():
				$Timer.start()
		move_and_slide()

func on_take_dmg():
	var original_color = self_modulate
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	if lives > 0:
		modulate = original_color

func die():
	died.emit()
	queue_free()

func _on_timer_timeout() -> void:
	get_parent().get_parent().shoot_enemy_attack(global_position.direction_to(player.global_position), position, damage, attack_speed)
	
