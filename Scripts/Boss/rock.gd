extends CharacterBody2D


@onready var player = get_tree().get_first_node_in_group("Player")
var detenation_pos: Vector2



var damage: int = 3

func _ready() -> void:
	$AnimationPlayer.play("shadow")
	velocity = Vector2(0, 700)
"""
Syfte: Ge stenen en start hastighet och en skugga som visar vart den kommer landa
"""

func _process(delta: float) -> void:
	$Shadow.global_position = detenation_pos
	if position.y >= detenation_pos.y:
		$Rock.hide()
		$Shadow.hide()
		set_physics_process(false)
		velocity.y = 0
		$ExplotionAnimation.show()
		$ExplotionAnimation.play("explotion")
		AudioController.play_explotion_sound()
		$Area2D.monitoring = true
		await $ExplotionAnimation.animation_finished
		queue_free()
"""
Syfte: Kolla att den inte har passerat sin destination och om den har expoldera den och ta bort den
"""

func _physics_process(delta: float) -> void:
	velocity.y += 50
	move_and_slide()
"""
Syfte: Accelerara stenen
"""

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(damage)
"""
Syfte: Skada spelaren om den är i explotionen
"""
