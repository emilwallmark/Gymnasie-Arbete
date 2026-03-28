extends CharacterBody2D
class_name Grenade

var speed = 500
var dir: Vector2

@onready var damage: int
@onready var range: int
func _ready() -> void:
	$Timer.wait_time = range*0.3
	$Timer.start()
"""
Syfte: Starta en timer som dödar skottet efter en tid
"""	
func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()
"""
Syfte: Få skottet att röra sig i rätt riktning
"""
func _process(_delta: float) -> void:
	movement()
"""
Syfte: Uppdatera movement() varje frame
"""
		
func _on_timer_timeout() -> void:
	speed = 0
	$Explotion_Area.monitoring = true
	$Sprite2D.visible = false
	$BOOM.visible = true
	$BOOM.play("BOOM")
	AudioController.play_explotion_sound()
"""
Syfte: Spränga granaten då tiden är slut, göra explotionen
"""

func _on_explotion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.lives -= damage
		body.on_take_dmg()
"""
Syfte: Se om en fiende är i explotionen och skada den
"""


func _on_boom_animation_finished() -> void:
	queue_free()
"""
Syfte: Ta bort granaten
"""
