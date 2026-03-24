extends CharacterBody2D


@onready var player = get_tree().get_first_node_in_group("Player")
var detenation_pos: Vector2



var damage: int = 3

func _ready() -> void:
	$AnimationPlayer.play("shadow")
	velocity = Vector2(0, 700)

func _process(delta: float) -> void:
	$Shadow.global_position = detenation_pos
	if position.y >= detenation_pos.y:
		$Rock.hide()
		$Shadow.hide()
		set_physics_process(false)
		velocity.y = 0
		$ExplotionAnimation.show()
		$ExplotionAnimation.play("explotion")
		AudioController.play_explition_sound()
		$Area2D.monitoring = true
		await $ExplotionAnimation.animation_finished
		queue_free()

func _physics_process(delta: float) -> void:
	velocity.y += 50
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(damage)
		
