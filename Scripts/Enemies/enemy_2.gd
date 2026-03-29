extends CharacterBody2D

signal died

const MAX_SPEED := 275
const ACC := 1500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Sprite2D

#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int
var max_lives: float = 4
var damage: int = 2
var dead = false
var time_scale = 1


func _ready() -> void:
	lives = max_lives
	anim.play("Enemy_Walk")
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
	elif velocity.x > 0:
		enemy_texture.flip_h = false
	if global_position.x > 4900 or global_position.x < -2400 or global_position.y > 4200 or global_position.y < -2400: 
		velocity = Vector2(0,0)
		global_position  = Vector2(0,0)	
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
		velocity *= time_scale
		move_and_slide()
"""
Syfte: Få fienden att gå mot spelaren varje frame
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
