extends CharacterBody2D
class_name Player

signal shoot

const SPEED = 250.0

@export var inventory: Inv

func movement(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down") * SPEED
	move_and_slide()
func shoot_bullet()->void:
	emit_signal("shoot")

func _physics_process(delta: float) -> void:
	movement(delta)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Action"):
		shoot_bullet()

		
	#print(get_local_mouse_position()[1])
