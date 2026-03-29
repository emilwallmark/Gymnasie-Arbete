extends CharacterBody2D
class_name Bullet

var dir: Vector2

@onready var damage: int
@onready var range: int
@onready var speed: int
@onready var multishot: bool

func _ready() -> void:
	$Timer.wait_time = 0.3*range
	$Timer.start()
	if multishot:
		var bullet_up = self.duplicate(15)
		bullet_up.multishot = false
		bullet_up.speed = speed
		bullet_up.range = range
		bullet_up.damage = damage
		bullet_up.dir = dir.rotated(deg_to_rad(15))
		get_parent().add_child(bullet_up)
		var bullet_down = self.duplicate(15)
		bullet_down.multishot = false
		bullet_down.speed = speed
		bullet_down.range = range
		bullet_down.damage = damage
		bullet_down.dir = dir.rotated(deg_to_rad(-15))
		get_parent().add_child(bullet_down)


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
