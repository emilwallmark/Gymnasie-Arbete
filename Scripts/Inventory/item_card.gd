extends Node2D

var item

@onready var player = get_tree().get_first_node_in_group("Player")

var cost_multi: float

func card_1():
	cost_multi = 1.0
	
	var i = randi() % 10
	if i >= 0 and i <= 2:
		var n = randi() % len(PreloadItems.health)
		item = PreloadItems.health[n]
	elif i >= 3 and i <= 5:
		var n = randi() % len(PreloadItems.common)
		item = PreloadItems.common[n]
	elif i >= 6 and i <= 7:
		var n = randi() % len(PreloadItems.rare)
		item = PreloadItems.rare[n]
	elif i >= 8 and i <= 9:
		var n = randi() % len(PreloadItems.epic)
		item = PreloadItems.epic[n]
	else:
		var n = randi() % len(PreloadItems.legendary)
		item = PreloadItems.legendary[n]
	
	$Pic.texture = item.texture
	if item.type == "health":
		$Label.text = str(item.damage)
		$Damage.text = "Healing"
		$Label4.text = ""
		$Range.text = ""
	else:
		$Label.text = str(item.damage)
		$Label4.text = str(item.range)
	$Label2.text = str(item.rarity)
	$Label3.text = str(roundi(item.cost * cost_multi))
	
func card_2():
	cost_multi = 1.25
	
	var i = randi() % 10
	
	if i >= 0 and i <= 1:
		var n = randi() % len(PreloadItems.health)
		item = PreloadItems.health[n]
	elif i >= 2 and i <= 3:
		var n = randi() % len(PreloadItems.common)
		item = PreloadItems.common[n]
	elif i >= 3 and i <= 6:
		var n = randi() % len(PreloadItems.rare)
		item = PreloadItems.rare[n]
	elif i >= 7 and i <= 9:
		var n = randi() % len(PreloadItems.epic)
		item = PreloadItems.epic[n]
	else:
		var n = randi() % len(PreloadItems.legendary)
		item = PreloadItems.legendary[n]
		
	$Pic.texture = item.texture
	if item.type == "health":
		$Label.text = str(item.damage)
		$Damage.text = "Healing"
		$Label4.text = ""
		$Range.text = ""
	else:
		$Label.text = str(item.damage)
		$Label4.text = str(item.range)
	$Label2.text = str(item.rarity)
	$Label3.text = str(roundi(item.cost * cost_multi))
	
func card_3():
	cost_multi = 2
	
	var i = randi() % 10
	if i >= 0 and i <= 1:
		var n = randi() % len(PreloadItems.health)
		item = PreloadItems.health[n]
	elif i >= 2 and i <= 5:
		var n = randi() % len(PreloadItems.rare)
		item = PreloadItems.rare[n]
	elif i >= 6 and i <= 8:
		var n = randi() % len(PreloadItems.epic)
		item = PreloadItems.epic[n]
	else:
		var n = randi() % len(PreloadItems.legendary)
		item = PreloadItems.legendary[n]
		
	$Pic.texture = item.texture
	if item.type == "health":
		$Label.text = str(item.damage)
		$Damage.text = "Healing"
		$Label4.text = ""
		$Range.text = ""
	else:
		$Label.text = str(item.damage)
		$Label4.text = str(item.range)
	$Label2.text = str(item.rarity)
	$Label3.text = str(roundi(item.cost * cost_multi))

func _on_button_pressed() -> void:
	var done = false
	var  x= 0
	
	if Globals.money >= item.cost:
		if item.type != "health":
			while not done:
				if x == 6:
					done = true
				elif player.inventory.items[x] == null:
					Globals.money -= roundi(item.cost * cost_multi)
					player.inventory.items.pop_at(x)
					player.inventory.items.insert(x, item) 
					player.get_child(11).get_child(0).update_slots()
					queue_free()
					done = true
				else:
					x += 1
		else:
			Globals.player_max_lives += item.damage
			Globals.player_lives = Globals.player_max_lives
			Globals.money -= roundi(item.cost * cost_multi)
			queue_free()
