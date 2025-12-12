extends Control

@onready var inv: Inv = preload("res://Inventory/PlayerInv.tres")
@onready var slots: Array = $InvSlotHolder.get_children()

func update_slots():
	for i in  range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
func _ready() -> void:
	update_slots()
