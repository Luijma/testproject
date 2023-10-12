extends PanelContainer


const Slot = preload("res://inventory/slot.tscn")
const Slot_Data = preload("res://inventory/slot_data.gd")
const no_item: = preload("res://Item/items/no_item.tres")

@onready var item_grid: GridContainer = $MarginContainer/ItemGrid
signal item_selected_in_inventory(item_data: ItemData)
var item_selected: ItemData


func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		slot.sent_item_info.connect(_received_item_data_from_slot)
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		#slot.item_button.button_clicked.connect(inventory_data.on_slot_clicked)
		if slot_data:
			slot.set_slot_data(slot_data)

func _received_item_data_from_slot(item_data: ItemData):
	item_selected = item_data
	if(item_data != null):
		print("item on inventory: " + item_data.name)
	else:
		print("item_selected should be null:" + str(item_selected))
	item_selected_in_inventory.emit(item_selected)
	
