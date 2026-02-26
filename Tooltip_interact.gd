extends Button

@onready var tooltip = $Tooltip
@onready var player = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	mouse_entered.connect(on_mouse_enterd)
	mouse_exited.connect(on_mouse_exited)
	
func on_mouse_enterd():
	for i in len(get_parent().get_children()):
		if self == get_parent().get_child(i):
			if player.inventory.items[i] != null:
				tooltip.n = i
				tooltip.toggle(true)
				

func on_mouse_exited():
	tooltip.toggle(false)
