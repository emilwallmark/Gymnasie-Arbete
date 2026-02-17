extends Node2D

var item

@onready var player = get_tree().get_first_node_in_group("Player")

func card_1():
	var i = randi() % 17
	item = PreloadItems.items[i]
	$Pic.texture = item.texture
	if item.type == "health":
		$Label.text = "Healing " + str(item.damage)
	else:
		$Label.text = "Dmg " + str(item.damage)
	$Label2.text = str(item.rarity)
	$Label3.text = str(item.cost)
func card_2():
	var i = randi() % 17
	item = PreloadItems.items[i]
	$Pic.texture = item.texture
	if item.type == "health":
		$Label.text = "Healing " + str(item.damage)
	else:
		$Label.text = "Dmg " + str(item.damage)
	$Label2.text = str(item.rarity)
	$Label3.text = str(item.cost)
func card_3():
	var i = randi() % 17
	item = PreloadItems.items[i]
	$Pic.texture = item.texture
	if item.type == "health":
		$Label.text = "Healing " + str(item.damage)
	else:
		$Label.text = "Dmg " + str(item.damage)
	$Label2.text = str(item.rarity)
	$Label3.text = str(item.cost)

func _on_button_pressed() -> void:
	var done = false
	var  x= 0
	if Globals.money >= item.cost:
		Globals.money -= item.cost
		if item.type != "health":
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
		else:
			Globals.player_max_lives += item.damage
			Globals.player_lives = Globals.player_max_lives
		queue_free()
