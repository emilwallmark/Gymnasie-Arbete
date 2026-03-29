extends CharacterBody2D

var speed: int
var dir: Vector2

var time_scale = 1.0

var delete_timer = 0.0
var delete_time = 5.0

@onready var moving: Sprite2D = $Moving
@onready var explotion: Sprite2D = $Explotion
@onready var anim: AnimationPlayer = $AnimationPlayer

@onready var damage: int

func _ready() -> void:
	anim.play("Moving")
	explotion.hide()
	add_to_group("enemy_bullets")
"""
Syfte: Starta animation
"""
func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	velocity *= time_scale
	move_and_slide()
"""
Syfte: Bestämma vilket håll skottet ska
"""
func _process(_delta: float) -> void:
	anim.speed_scale = time_scale
	var scaled_delta = time_scale * _delta
	delete_timer += scaled_delta
	if delete_timer >= delete_time:
		set_process(false)
		moving.hide()
		explotion.show()
		anim.play("Exploding")
		AudioController.play_explotion_sound()
		await anim.animation_finished
		queue_free()
	movement()
"""
Syfte: Röra skottet varje frame
"""
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		set_process(false)
		moving.hide()
		explotion.show()
		anim.play("Exploding")
		body.take_damage(damage)
		AudioController.play_explotion_sound()
		await anim.animation_finished
		queue_free()
		
"""
Syfte: Skada spelaren om den blir träffad och köra explotion animationen
"""
