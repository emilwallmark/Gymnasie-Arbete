extends CharacterBody2D
class_name Bullet

var dir: Vector2

@onready var damage: int
@onready var range: int
@onready var speed: int

func _ready() -> void:
	$Timer.wait_time = 0.3*range
	$Timer.start()
	

func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()

func _process(_delta: float) -> void:
	movement()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()
		body.lives -= damage
		body.on_take_dmg()
		
func _on_timer_timeout() -> void:
	queue_free() 
