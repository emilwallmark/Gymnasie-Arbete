extends CharacterBody2D

class_name Enemy

const MAX_SPEED := 250
const ACC := 1500

@onready var health_bar = $HpBar

#Kommer defineras av föreldern som har åtkomst till sina barn
var player = null
var lives = 3

func _process(delta: float) -> void:
	if lives <= 0:
		queue_free()
	health_bar.size[0] = 150 * lives/3

func _physics_process(delta: float) -> void:
	if player:
		var direction_to_player = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction_to_player*MAX_SPEED, ACC*delta)
		move_and_slide()
