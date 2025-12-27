extends CharacterBody2D

class_name Enemy

const MAX_SPEED := 250
const ACC := 1500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Sprite2D
@onready var collision_body: CollisionShape2D = $EnemyCollisionBody

#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives = 3

func _ready() -> void:
	anim.play("Enemy_Walk")

func _process(_delta: float) -> void:
	health_bar.size[0] = 150 * lives/3
	if velocity.x < 0:
		enemy_texture.flip_h = true
	else:
		enemy_texture.flip_h = false

func _physics_process(delta: float) -> void:
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*delta)
		move_and_slide()

func on_take_dmg():
	var original_color = self_modulate
	modulate = Color.RED
	if lives < 1:
		collision_body.disabled = true
	await get_tree().create_timer(0.2).timeout
	if lives > 0:
		modulate = original_color
	else:
		var random = randi() % 2
		if random == 1:
			Globals.money += 1
		queue_free()
