extends CharacterBody2D

var speed: int
var dir: Vector2

@onready var moving: Sprite2D = $Moving
@onready var explotion: Sprite2D = $Explotion
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var damage: int

func _ready() -> void:
	anim.play("Moving")
	explotion.hide()

func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()

func _process(_delta: float) -> void:
	movement()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_process(false)
		moving.hide()
		explotion.show()
		anim.play("Exploding")
		await anim.animation_finished
		queue_free()
		body.take_damage(damage)
		
func _on_timer_timeout() -> void:
	set_process(false)
	moving.hide()
	explotion.show()
	anim.play("Exploding")
	await anim.animation_finished
	queue_free() 
