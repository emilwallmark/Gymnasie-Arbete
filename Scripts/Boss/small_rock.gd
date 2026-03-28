extends CharacterBody2D


@onready var random_rock: int = randi()%6
@onready var rock_texture: Sprite2D = $RockTexture
@onready var player = get_tree().get_first_node_in_group("Player")

var damage: int = 2


func _ready() -> void:
	rock_texture.frame = random_rock
	velocity = Vector2(0, 700)
	await get_tree().create_timer(10).timeout
	queue_free()
"""
Syfte: Ge varje sten en random textur och en start hastighet och starta en timer som tar bort dem efter en period
"""


func _process(delta: float) -> void:
	velocity.y += 50
	move_and_slide()
"""
Syfte: Accelerara stenarna
"""

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(damage)
"""
Syfte: Skada spelaren om den blir träffad av någon av stenarna
"""
