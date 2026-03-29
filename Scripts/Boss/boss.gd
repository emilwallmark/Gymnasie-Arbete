extends CharacterBody2D

signal died

const MAX_SPEED := 150
const ACC := 1500

const ROCK_SCENE = preload("res://Scenes/Boss/Rock.tscn")
const SMALL_ROCK_SCENE = preload("res://Scenes/Boss/Small_rock.tscn")
const SWIPE_SCENE = preload("res://Scenes/Boss/Swipe.tscn")

@onready var health_bar = $CanvasLayer/HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var walk_texture: Sprite2D = $Walk
@onready var attack_1_texture: Sprite2D = $Attack1
@onready var attack_2_texture : Sprite2D = $Attack2
@onready var attack_3_texture: Sprite2D = $Attack3
@onready var jump_attack_texture: Sprite2D = $JumpAttack
@onready var smoke_texture: Sprite2D = $smoke

#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int
var max_lives: float = 300
var damage: int = 1
var dead = false

var time_scale = 1.0
var attack_timer = 0.0
var attack_interval  = 5.0

func _ready() -> void:
	anim.play("Walk")
	lives = max_lives
"""
Syfte: Ge bossen rätt liv och starta animationen
"""

func _process(_delta: float) -> void:
	health_bar.value = lives/max_lives * 100
	if lives <= 0 and !dead:
		dead = true
		await get_tree().create_timer(0.2).timeout
		die()
	if velocity.x < 0:
		walk_texture.flip_h = true
		smoke_texture.position.x = 6.333
	elif velocity.x > 0:
		walk_texture.flip_h = false
		smoke_texture.position.x = -6.333
	if velocity != Vector2(0,0):
		AudioController.play_boss_walking_sound()
	anim.speed_scale = time_scale
"""
Syfte: Kolla om den är död och få texturen att vara åt rätt håll
"""

func _physics_process(delta: float) -> void:
	if player:
		var scaled_delta = delta*time_scale
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*scaled_delta)
		if velocity > direction_to_player*MAX_SPEED:
			velocity = direction_to_player*MAX_SPEED
		attack_timer += scaled_delta
		if attack_timer >= attack_interval:
			attack_timer = 0.0
			set_physics_process(false)
			var x = randi() % 4
			if x == 0:
				attack_1()
			elif x == 1:
				attack_2()
			elif x == 2:
				attack_3()
			elif x == 3:
				jump_attack()
		velocity *= time_scale
		move_and_slide()
"""
Syfte: Få den att gå mot spelaren konstant och utföra attackerna
"""

func attack_1():
	if velocity.x < 0:
		attack_1_texture.flip_h = true
		smoke_texture.position.x = 6.333
	elif velocity.x > 0:
		attack_1_texture.flip_h = false
		smoke_texture.position.x = -6.333
	velocity = Vector2(0,0)
	var rock = ROCK_SCENE.instantiate()
	walk_texture.hide()
	attack_1_texture.show()
	anim.play("Attack_1")
	await  anim.animation_finished
	AudioController.play_boss_attack_1_sound()
	rock.global_position = player.global_position - Vector2(0, 1400)
	rock.detenation_pos = player.global_position
	get_parent().add_child(rock)
	attack_1_texture.hide()
	walk_texture.show()
	anim.play("Walk")
	set_physics_process(true)
"""
Syfte: Utföra attack 1
"""

func attack_2():
	var swipe = SWIPE_SCENE.instantiate()
	if velocity.x < 0:
		attack_2_texture.flip_h = true
		smoke_texture.position.x = 6.333
		swipe.velocity.x = -1000
		swipe.scale.x = -5
	elif velocity.x >= 0:
		attack_2_texture.flip_h = false
		smoke_texture.position.x = -6.333
		swipe.velocity.x = 1000
		swipe.scale.x = 5
	walk_texture.hide()
	attack_2_texture.show()
	anim.play("Attack_2")
	AudioController.play_swosh_sound()
	velocity = Vector2(0,0)
	await get_tree().create_timer(0.5).timeout
	swipe.global_position = global_position 
	get_parent().add_child(swipe)
	await  anim.animation_finished
	attack_2_texture.hide()
	walk_texture.show()
	anim.play("Walk")
	set_physics_process(true)
"""
Syfte: Utföra attack 2
"""
func attack_3():
	if velocity.x < 0:
		attack_3_texture.flip_h = true
		smoke_texture.position.x = 6.333
	elif velocity.x > 0:
		attack_3_texture.flip_h = false
		smoke_texture.position.x = -6.333
	velocity = Vector2(0,0)
	walk_texture.hide()
	attack_3_texture.show()
	anim.play("Attack_3")
	AudioController.play_screech_sound()
	await anim.animation_finished
	for n in range(2):	
		get_parent().spawn_enemy("splitter")
		await get_tree().create_timer(0.5).timeout
	attack_3_texture.hide()
	walk_texture.show()
	anim.play("Walk")
	set_physics_process(true)
"""
Syfte: Utföra attack 3
"""
		
		

func jump_attack():
	var n = -3
	if velocity.x < 0:
		jump_attack_texture.flip_h = true
		smoke_texture.position.x = 6.333
	elif velocity.x > 0:
		jump_attack_texture.flip_h = false
		smoke_texture.position.x = -6.333
	velocity = Vector2(0,0)
	walk_texture.hide()
	jump_attack_texture.show()
	anim.play("Jump_attack")
	await anim.animation_finished
	AudioController.play_boss_attack_1_sound()
	var player_pos = player.global_position
	for i in range(7):
		var rock = SMALL_ROCK_SCENE.instantiate()
		rock.global_position = Vector2(player_pos.x + n*150, player_pos.y -1400)
		get_parent().add_child(rock)
		n += 1
	walk_texture.show()
	jump_attack_texture.hide()
	anim.play("Walk")
	set_physics_process(true)
"""
Syfte: Utföra jump attack
"""

func on_take_dmg():
	var original_color = self_modulate
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	if lives > 0:
		modulate = original_color
"""
Syfte: Få den att blinka rött då den tar skada
"""

func die():
	died.emit()
	Globals.money += 1
	AudioController.play_boss_die_sound()
	queue_free()
"""
Syfte: Döda den då denns liv är slut
"""
