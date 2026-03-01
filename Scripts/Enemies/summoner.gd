extends CharacterBody2D

signal died

const MAX_SPEED := 50
const ACC := 1500
const attack_speed = 500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Walk
@onready var enemy_texture2: Sprite2D = $Summoning


#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int
var max_lives: float = 30
var damage: int = 12
var distance_to_player 
var dead = false

func _ready() -> void:
	anim.play("Walk")
	enemy_texture2.hide()
	lives = max_lives

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


func _physics_process(delta: float) -> void:
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*delta)
		if velocity > direction_to_player*MAX_SPEED:
			velocity = direction_to_player*MAX_SPEED
		move_and_slide()

func on_take_dmg():
	var original_color = self_modulate
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	if lives > 0:
		modulate = original_color

func die():
	died.emit()
	Globals.money += 3
	queue_free()


func _on_timer_timeout() -> void:
	get_parent().spawn_enemy("fire_spirit")
	enemy_texture2.show()
	enemy_texture.hide()
	anim.play("Summon")
	await anim.animation_finished
	anim.play("Walk")
	enemy_texture.show()
	enemy_texture2.hide()
	
