extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var camera: Camera2D = player.get_child(0)

var enemy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport = get_viewport().get_visible_rect()
	viewport.position = get_viewport().get_visible_rect().position + camera.global_position - Vector2(1280, 720)
	
	if enemy != null:
		if !viewport.has_point(enemy.position) and enemy != null:
			visible = true
		else:
			visible = false
		rotation = player.global_position.angle_to_point(enemy.global_position) + PI/2
		position = Vector2(500*cos(rotation-PI/2) + 1280, 500 *sin(rotation-PI/2) + 720)
	else:
		queue_free()
	
	
