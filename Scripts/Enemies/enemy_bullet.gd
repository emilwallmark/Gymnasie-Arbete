extends CharacterBody2D

var speed: int
var dir: Vector2

@onready var damage: int

func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()

func _process(_delta: float) -> void:
	movement()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		queue_free()
		body.take_damage(damage)
		
func _on_timer_timeout() -> void:
	queue_free() 
