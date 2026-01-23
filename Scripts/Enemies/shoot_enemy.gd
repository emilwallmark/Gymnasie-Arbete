extends CharacterBody2D


const MAX_SPEED := 250
const ACC := 1500


@onready var health_bar = $HpBar
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var enemy_texture: Sprite2D = $Sprite2D
#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives: int = 5
var damage: int = 2
var distance_to_player 


func _process(_delta: float) -> void:
	health_bar.size[0] = 150 * lives/5
	if velocity.x < 0:
		enemy_texture.flip_h = true
	elif velocity.x > 0:
		enemy_texture.flip_h = false
	if velocity.x != 0 or velocity.y != 0:
		anim.play("Enemy_Walk")
	else:
		pass
		anim.play("Idle")

func _physics_process(delta: float) -> void:
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		distance_to_player = sqrt((global_position.x-player.global_position.x)**2 + (global_position.y - player.global_position.y)**2)
		if distance_to_player > 300:
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
	else:
		var random = randi() % 2
		if random == 1:
			Globals.money += 1
		queue_free()


func _on_timer_timeout() -> void:
	get_parent().shoot_enemy_attack(global_position.direction_to(player.global_position), position, damage)
	
