extends Node2D

@onready var damage: int
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var range: int
@onready var multishot: bool

func _ready() -> void:
	$Timer.start()
	$AnimationPlayer.play("Attack_Anim")
	$Area2D/CollisionShape2D.position.x += 20*range
	if range*2 > 7:
		$Sprite2D.scale = Vector2(range*2, range*2)
	else:
		$Sprite2D.scale = Vector2(7, 7)
	if multishot:
		var sword_up = self.duplicate(15)
		sword_up.multishot = false
		sword_up.player = player
		sword_up.range = range
		sword_up.damage = damage
		sword_up.rotation = rotation + 2*PI/3
		get_parent().add_child(sword_up)
		var sword_down = self.duplicate(15)
		sword_down.multishot = false
		sword_down.player = player
		sword_down.range = range
		sword_down.damage = damage
		sword_down.rotation = rotation - 2*PI/3
		get_parent().add_child(sword_down)
"""
Göra animationen och göra spriten nog stor
"""

func _process(float) -> void:
	var angle = rotation
	position = player.position + Vector2.RIGHT.rotated(angle)*50
"""
Syfte: röra vapnet då spelaren rör sig
"""
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.lives -= damage
		body.on_take_dmg()
"""
Syfte: Skada fiender om de är i hitboxen
"""

func _on_timer_timeout() -> void:
	queue_free()
"""
Syfte: Ta bort vapnet
"""
