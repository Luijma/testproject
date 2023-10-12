extends Button

@onready var slot = $".."

signal item_selected(item: ItemData)
signal button_clicked(index: int, button: int)

func _on_pressed():
	print("ITEM SELECTED")
	#item_selected.emit(slot.item_data)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot.slot_clicked.emit(slot.get_index(), event.button_index)
		item_selected.emit(slot.item_data)
		print("entered on_gui_input from item_button")
