extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")

var damage: int = 2
var time_scale = 1.0

func _ready() -> void:
	add_to_group("enemy_bullets")
	await get_tree().create_timer(10).timeout
	queue_free()
"""
Syfte: Ta bort den efter en period
"""

func _process(delta: float) -> void:
	velocity *= time_scale
	move_and_slide()
"""
Syfte: Då den att faktist kunna röra sig
"""

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(damage)
"""
Syfte: Skada spelaren om den blir träffad av den
"""
