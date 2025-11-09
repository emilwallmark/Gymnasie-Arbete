extends CharacterBody2D
class_name Bullet

var speed = 500
var dir = Vector2(1,1)

@onready var damage: int

func movement(dir: Vector2) -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(damage) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(dir)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.lives -= damage
		queue_free()


func _on_timer_timeout() -> void:
	queue_free() 
