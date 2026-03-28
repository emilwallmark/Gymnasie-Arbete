extends Panel


@onready var item_visual: TextureRect = $CenterContainer/Panel/item_display

func update(item: InvItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
"""
Syfte: Updatera den spesifika item_sloten så att den visar rätt
"""
