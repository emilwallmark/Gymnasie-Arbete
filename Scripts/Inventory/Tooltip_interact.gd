extends Button

@onready var tooltip = $Tooltip
@onready var player = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	mouse_entered.connect(on_mouse_enterd)
	mouse_exited.connect(on_mouse_exited)
"""
Syfte: Connecta signaler för att känna om musen är över knappen eller inte
"""

func on_mouse_enterd():
	for i in len(get_parent().get_children()):
		if self == get_parent().get_child(i):
			if player.inventory.items[i] != null:
				tooltip.n = i
				tooltip.toggle(true)
"""
Syfte: Visa tooltip om musen är ovanför knappen och itemslott inte är tom
"""

func on_mouse_exited():
	tooltip.toggle(false)
"""
Syfte: Sluta visa tooltip om musen inte är på knappen
"""
