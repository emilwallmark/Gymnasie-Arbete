extends CharacterBody2D

signal died

const MAX_SPEED := 600
const ACC := 1500
const attack_speed = 500

@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture_1: Sprite2D = $Idle
@onready var enemy_texture_2: Sprite2D = $Walking

var player = null
var lives: int
var max_lives: float = 5
var damage: int = 2
var exploding_damage: int = 4
var distance_to_player 
var exploding:bool = false
var dead = false

func _ready() -> void:
	lives = max_lives

func _process(_delta: float) -> void:
	health_bar.value = lives/max_lives * 100
	if lives <= 0 and !exploding and !dead:
		dead = true
		await get_tree().create_timer(0.2).timeout
		die()
	if velocity.x < 0:
		enemy_texture_1.flip_h = false
		enemy_texture_2.flip_h = false
	elif velocity.x > 0:
		enemy_texture_1.flip_h = true
		enemy_texture_2.flip_h = true
	if velocity.x != 0 or velocity.y != 0:
		enemy_texture_2.visible = true
		enemy_texture_1.visible = false
		anim.play("Enemy_Walk")
	else:
		if !exploding:
			enemy_texture_2.visible = false
			enemy_texture_1.visible = true
			anim.play("Fuse")

func _physics_process(delta: float) -> void:
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		distance_to_player = sqrt((global_position.x-player.global_position.x)**2 + (global_position.y - player.global_position.y)**2)
		if distance_to_player > 150:
			velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*delta)
			$Timer.stop()
		else: 
			velocity = Vector2(0,0)
			if $Timer.is_stopped():
				$Timer.start()
		move_and_slide()

func on_take_dmg():
	var original_color = self_modulate
	enemy_texture_1.modulate = Color.RED
	enemy_texture_2.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	if lives > 0:
		enemy_texture_1.modulate = original_color
		enemy_texture_2.modulate = original_color

func die():
	died.emit()
	queue_free()

func _on_timer_timeout() -> void:
	exploding = true
	$ExplotionArea.monitoring = true
	$BOOM.visible = true
	enemy_texture_1.visible = false
	$BOOM.play("BOOM")	
	lives = 0

func _on_boom_animation_finished() -> void:
	die()


func _on_explotion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(exploding_damage)
