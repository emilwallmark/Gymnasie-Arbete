extends CharacterBody2D
class_name Bullet

var speed = 500
var dir: Vector2

@onready var damage: int

func movement(dir: Vector2) -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()

func _process(delta: float) -> void:
	movement(dir)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		queue_free()
		body.lives -= damage
		
func _on_timer_timeout() -> void:
	queue_free() 
