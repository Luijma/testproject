extends PanelContainer


signal sent_item_info(itemData: ItemData) 
signal slot_clicked(index: int, button: int)
signal item_selected(item: ItemData)
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel
@onready var item_button: Button = $Item_Button
var item_data

func _ready():
	item_button.item_selected.connect(_selected_button)
	pass

func set_slot_data(slot_data: SlotData) -> void:
	item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]

	if slot_data.quantity > 1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.show()

func _selected_button(item_data: ItemData):
	if item_data != null:
		print("item: " + item_data.name)
	else:
		print("Inside else _selected_button for slot")
	sent_item_info.emit(item_data)
