extends CharacterBody2D

var speed: int
var dir: Vector2

var time_scale = 1.0

var delete_timer = 0.0
var delete_time = 5.0

@onready var damage: int

func _ready() -> void:
	add_to_group("enemy_bullets")
"""
Syfte: lägga till skottet till gruppen
"""

func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	velocity *= time_scale
	move_and_slide()
"""
Syfte: Bestäma vilken riktning skottet ska röra sig
"""
func _process(_delta: float) -> void:
	var scaled_delta = time_scale * _delta
	delete_timer += scaled_delta
	if delete_timer >= delete_time:
		queue_free()
	movement()
"""
Syfte: Röra skottet varje frame
"""
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		queue_free()
		if !body.invincibility_active:
			body.take_damage(damage)
"""
Syfte: Om skottet träffar spelaren ska den skada spelaren och försvinna
"""	
