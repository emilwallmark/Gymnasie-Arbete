extends Control

@onready var inv: Inv = preload("res://Scripts/Inventory/PlayerInv.tres")
@onready var slots: Array = $InvSlotHolder.get_children()

@onready var player = get_tree().get_first_node_in_group("Player")

func update_slots():
	for i in  range(min(inv.items.size(), slots.size())):
		slots[i].update(inv.items[i])
		
		
func _ready() -> void:
	update_slots()

func _on_button_1_pressed() -> void:
	var n: int = 0
	for i in player.inventory.items:
		if i == null:
			n += 1
	if n != 5:
		player.inventory.items[0] = null
		update_slots()
	else:
		$InvButtonHolder/Button1.get_child(0).anim.play("error")
		$InvButtonHolder/Button1.get_child(0).start_sway()
func _on_button_2_pressed() -> void:
	var n: int = 0
	for i in player.inventory.items:
		if i == null:
			n += 1
	if n != 5:
		player.inventory.items[1] = null
		update_slots()
	else:
		$InvButtonHolder/Button2.get_child(0).anim.play("error")
		$InvButtonHolder/Button2.get_child(0).start_sway()

func _on_button_3_pressed() -> void:
	var n: int = 0
	for i in player.inventory.items:
		if i == null:
			n += 1
	if n != 5:
		player.inventory.items[2] = null
		update_slots()
	else:
		$InvButtonHolder/Button3.get_child(0).anim.play("error")
		$InvButtonHolder/Button3.get_child(0).start_sway()

func _on_button_4_pressed() -> void:
	var n: int = 0
	for i in player.inventory.items:
		if i == null:
			n += 1
	if n != 5:
		player.inventory.items[3] = null
		update_slots()
	else:
		$InvButtonHolder/Button4.get_child(0).anim.play("error")
		$InvButtonHolder/Button4.get_child(0).start_sway()

func _on_button_5_pressed() -> void:
	var n: int = 0
	for i in player.inventory.items:
		if i == null:
			n += 1
	if n != 5:
		player.inventory.items[4] = null
		update_slots()
	else:
		$InvButtonHolder/Button5.get_child(0).anim.play("error")
		$InvButtonHolder/Button5.get_child(0).start_sway()

func _on_button_6_pressed() -> void:
	var n: int = 0
	for i in player.inventory.items:
		if i == null:
			n += 1
	if n != 5:
		player.inventory.items[5] = null
		update_slots()
	else:
		$InvButtonHolder/Button6.get_child(0).anim.play("error")
		$InvButtonHolder/Button6.get_child(0).start_sway()
	
