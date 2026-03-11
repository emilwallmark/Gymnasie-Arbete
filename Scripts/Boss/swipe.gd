extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

var damage: int = 2

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	queue_free()

func _process(delta: float) -> void:
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(damage)
