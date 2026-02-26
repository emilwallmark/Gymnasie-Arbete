extends Control

@onready var inv: Inv = preload("res://Scripts/PlayerInv.tres")
@onready var slots: Array = $InvSlotHolder.get_children()

@onready var player = get_tree().get_first_node_in_group("Player")

func update_slots():
	for i in  range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
		
		
func _ready() -> void:
	update_slots()

func _on_button_1_pressed() -> void:
	player.inventory.items[0] = null
	update_slots()

func _on_button_2_pressed() -> void:
	player.inventory.items[1] = null
	update_slots()

func _on_button_3_pressed() -> void:
	player.inventory.items[2] = null
	update_slots()

func _on_button_4_pressed() -> void:
	player.inventory.items[3] = null
	update_slots()

func _on_button_5_pressed() -> void:
	player.inventory.items[4] = null
	update_slots()

func _on_button_6_pressed() -> void:
	player.inventory.items[5] = null
	update_slots()
	
