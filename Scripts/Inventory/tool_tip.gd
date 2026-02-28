extends PanelContainer

@onready var n: int
@onready var stats = $HBoxContainer/VBoxContainer/StatsContent
@onready var text = $HBoxContainer/VBoxContainer/TextContainer2


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
