extends CharacterBody2D
class_name Grenade

var speed = 500
var dir: Vector2

@onready var damage: int


func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()

func _process(_delta: float) -> void:
	movement()

		
func _on_timer_timeout() -> void:
	speed = 0
	$Explotion_Area.monitoring = true
	$Sprite2D.visible = false
	$BOOM.visible = true
	$BOOM.play("BOOM")


func _on_explotion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.lives -= damage
		body.on_take_dmg()
		


func _on_boom_animation_finished() -> void:
	queue_free()
