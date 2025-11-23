extends CharacterBody2D
class_name Player

signal attack

const SPEED = 250.0

var direction = "Down"

@onready var anim: AnimationPlayer = $AnimationPlayer


@export var inventory: Inv

func movement(delta: float) -> void:
	velocity = Input.get_vector("Left", "Right", "Up", "Down") * SPEED
	move_and_slide()
func _attack()->void:
	emit_signal("attack")

func _physics_process(delta: float) -> void:
	movement(delta)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Action"):
		_attack()
	animation()


func animation():
	if velocity[0] == 0 and velocity[1] == 0 and direction == "Down":
		anim.play("Idle_Down")
	elif velocity[0] == 0 and velocity[1] == 0 and direction == "Up":
		anim.play("Idle_Up")
	elif velocity[0] == 0 and velocity[1] == 0 and direction == "Left":
		anim.play("Idle_Left")
	elif velocity[0] == 0 and velocity[1] == 0 and direction == "Right":
		anim.play("Idle_Right")
	elif velocity[0] < 0:
		anim.play("Walk__Left")
		direction = "Left"
	elif velocity[0] > 0:
		anim.play("Walk_Right")
		direction = "Right"
	elif velocity[1] < 0:
		anim.play("Walk_Up")
		direction = "Up"
	else:
		anim.play("Walk_Down")
		direction = "Down"
