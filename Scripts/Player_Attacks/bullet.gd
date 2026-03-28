extends CharacterBody2D
class_name Bullet

var dir: Vector2

@onready var damage: int
@onready var range: int
@onready var speed: int

func _ready() -> void:
	$Timer.wait_time = 0.3*range
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()
		body.lives -= damage
		body.on_take_dmg()
"""
Syfte: Om skottet träffar något så ska skottet försvinna och skada fienden
"""

func _on_timer_timeout() -> void:
	queue_free() 
"""
Syfte: Ta bort skottet efter timer har tagit slut
"""
