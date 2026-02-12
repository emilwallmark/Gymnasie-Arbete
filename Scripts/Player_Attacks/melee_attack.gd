extends Node2D

@onready var damage: int
@onready var player = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	$AnimationPlayer.play("Attack_Anim")

func _process(float) -> void:
	var angle = rotation
	position = player.position + Vector2.RIGHT.rotated(angle)*50

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.lives -= damage
		body.on_take_dmg()


func _on_timer_timeout() -> void:
	queue_free()
