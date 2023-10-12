extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_datas: Array[SlotData]

func grab_slot_data(index: int) -> SlotData:
	#If it is null, it is NOT calling this function. why? only after item previously selected
	var slot_data = slot_datas[index]
	print("pre ifelse grab_slot_data" + str(slot_data))
	if slot_data:
		print("grab_slot_data = " + slot_data.item_data.name)
		return slot_data
	else:
		print("else in grab_slot_data: " + str(slot_data))
		return null

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)
	
func remove_item(index: int) -> void:
	var item_to_remove = slot_datas[index]
	print("remove_item: removing " + item_to_remove.item_data.name + " on index: " + str(index))
	slot_datas[index] = null
	print("slot empty: " + str(slot_datas[index]))
	inventory_updated.emit(self)

func add_item(slot_data: SlotData) -> bool:
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	return false

func transfer_to_storage(index_player: int, index_storage: int):
	pass
