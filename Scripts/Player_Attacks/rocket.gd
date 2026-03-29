extends CharacterBody2D
class_name Rocket

var speed = 500
var dir: Vector2

@onready var damage: int
@onready var range: int
@onready var multishot: bool

func _ready() -> void:
	$AnimationPlayer.play("Fly_Anim")
	$Timer.wait_time = range*0.3
	$Timer.start()
	if multishot:
		var rocket_up = self.duplicate(15)
		rocket_up.multishot = false
		rocket_up.range = range
		rocket_up.damage = damage
		rocket_up.dir = dir.rotated(deg_to_rad(15))
		get_parent().add_child(rocket_up)
		var rocket_down = self.duplicate(15)
		rocket_down.multishot = false
		rocket_down.range = range
		rocket_down.damage = damage
		rocket_down.dir = dir.rotated(deg_to_rad(-15))
		get_parent().add_child(rocket_down)
"""
Syfte: Starta timer för att ta bort den och den vanliga animationen
"""

func movement() -> void:
	var length = (dir[0]**2 + dir[1]**2)**0.5
	velocity = Vector2(dir[0]*speed/length, dir[1]*speed/length)
	move_and_slide()
"""
Syfte: Röra raketen i rätt rikning
"""
func _process(_delta: float) -> void:
	movement()
"""
Syfte: Köra movement() varje frame
"""
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		speed = 0
		$Explotion_Area.monitoring = true
		$Sprite2D.visible = false
		$BOOM.visible = true
		$BOOM.play("BOOM")
		AudioController.play_explotion_sound()
"""
Syfte: Om raketen träffar en fiende så ska den köra explotionen
"""
		
func _on_timer_timeout() -> void:
	queue_free() 
"""
Syfte: Ra bort raketen
"""

func _on_explotion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.lives -= damage
		body.on_take_dmg()
"""
Syfte: Skada fiender som är i explotionen
"""


func _on_boom_animation_finished() -> void:
	queue_free()
"""
Syfte: ta bort raketen
"""
