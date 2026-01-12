extends Node2D

@onready var damage: int

func _ready() -> void:
	$AnimationPlayer.play("Attack_Anim")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.lives -= damage
		body.on_take_dmg()


func _on_timer_timeout() -> void:
	queue_free()
