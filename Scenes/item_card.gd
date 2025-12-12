extends Node2D

var item = PreloadItems.item
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:

	$Pic.texture = item.texture
	$Label.text = str(item.damage)
	$Label2.text = str(item.rarity)
	$Label3.text = str(item.cost)

func update():
	visible = true
	print("bleh")

func _on_button_pressed() -> void:
	visible = false
	var done = false
	var  x= 0
	if Globals.money >= item.cost:
		Globals.money -= item.cost
		while not done:
			if x == 6:
				done = true
			elif player.inventory.items[x] == null:
				player.inventory.items.pop_at(x)
				player.inventory.items.insert(x, item) 
				player.get_child(11).get_child(0).update_slots()
				done = true
			else:
				x += 1
