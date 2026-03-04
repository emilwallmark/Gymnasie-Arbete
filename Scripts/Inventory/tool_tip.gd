extends PanelContainer

@onready var n: int
@onready var stats = $HBoxContainer/VBoxContainer/StatsContent
@onready var text = $HBoxContainer/VBoxContainer/TextContainer2
@onready var anim = $AnimationPlayer


var base_pos = Vector2.ZERO
var shift = 20.0

func start_sway():
	var tween = create_tween()
	tween.tween_property(self, "position:x", base_pos.x + shift, 0.1)
	tween.tween_property(self, "position:x", base_pos.x - shift, 0.1)
	tween.tween_property(self, "position:x", base_pos.x + shift, 0.1)
	tween.tween_property(self, "position:x", base_pos.x - shift, 0.1)
func _process(delta):
	base_pos = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + Vector2(10,10)

func toggle(on: bool):
	if on:
		show()
		var item = get_tree().get_first_node_in_group("Player").inventory.items[n]
		text.text = str(item.name) + "\n" + str(item.type).capitalize() + "\n" + str(item.rarity)
		stats.text = str(item.damage) + "\n" + str(item.range)

	else:
		hide()
