extends Control

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var description = $Description


@onready var item_option_container = $item_option_container
@onready var equiped_item_texture = $EquipedItemTexture


# Item Option Code
const Item_Option = preload("res://Item/item_option.tscn")
const no_item = preload("res://Item/items/no_item.tres")
signal item_was_equiped(item_data)
signal item_unequiped(item_data)
signal item_was_discarded(slot_data: SlotData)

const weapon_item_options = ["EQUIP", "RELOAD", "DISCARD", "UNEQUIP"]
const healing_item_options = ["CONSUME", "DISCARD", "CANCEL"]
const key_item_options = ["EQUIP", "CANCEL", "UNEQUIP"]

#Selected Items
@onready var currently_selected_item: ItemData
# ITEM DATA IS NOT MEANT TO BE USED IN THIS WAY, REFACTOR CODE TO ONLY ACECESS ITEM DATA THROUGH SLOT DATA
@onready var grabbed_slot_data: SlotData
@onready var grabbed_slot_index: int
@onready var prev_mouse_mode = Input.mouse_mode


func _ready():
	player_inventory.item_selected_in_inventory.connect(_update_inventory_description)
	#player_inventory.item_selected_in_inventory.connect(_generate_item_options)
	#item_option.option_selected.connect(_handle_item_option_selection)
	item_was_equiped.connect(set_equiped_item)
	#player.toggle_inventory.connect(toggle_inventory_interface)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)
	
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int):
	print("%s %s %s" % [inventory_data, index, button])
	match [button]:
		[MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
			grabbed_slot_index = index
	
	if(grabbed_slot_data):
		print("grabbed_slot_data.name on_inventory_interact: " + grabbed_slot_data.item_data.name)
	else:
		print("pure slot data on inventory_interact: " + str(grabbed_slot_data))

func _update_inventory_description(item_data: ItemData):
	if item_data != null:
		print("item in inventory_interface scene: " + item_data.name)
		description.text = item_data.description
	else:
		print("item _update_inventory_description: " + str(item_data))
	currently_selected_item = item_data
	_generate_item_options()
		
func set_equiped_item(equiped_item: ItemData):
	#equiped_item_texture.set_texture(equiped_item.texture)
	pass

func _generate_item_options():
	#FIX FUNCTION: NEED TO FIGURE OUT HOW TO GENERATE ITEM OPTIONS. MAYBE I CAN IGNORE THE ITEM OPTION AND JUST CREATE BUTTONS WITH TEXTURES
	print("generating item options")
	for child in item_option_container.get_children():
		child.queue_free()
	if currently_selected_item != null and currently_selected_item.name != "No Item":
		print("Selected: " + currently_selected_item.name)
		if currently_selected_item.is_weapon:
			for option in weapon_item_options:
				var new_option = Item_Option.instantiate()
				new_option.option_selected.connect(_handle_item_option_selection)
				item_option_container.add_child(new_option)
				new_option.set_item_option_info(option)
		elif !currently_selected_item.is_weapon:
			for option in key_item_options:
				var new_option = Item_Option.instantiate()
				new_option.option_selected.connect(_handle_item_option_selection)
				item_option_container.add_child(new_option)
				new_option.set_item_option_info(option)

func _handle_item_option_selection(button: Button):
	print("handle_item_option_selection called in inventory_interface")
	match button.text:
		null:
			print("Error: No Item currently Selected.")
		"EQUIP":
			item_was_equiped.emit(currently_selected_item)
			#set_equiped_item instead of doing it here
			equiped_item_texture.texture = currently_selected_item.texture
		"UNEQUIP":
			item_was_equiped.emit(no_item)
			# Pop up asking for confirmation that you intend to unequip the current item
			equiped_item_texture.texture = null
			print("ITEM UNEQUIPED")
		"DISCARD":
			item_was_discarded.emit(grabbed_slot_index)
			print("DISCARD Detected")
		_:
			print("Unhandled option Selected: " + button.text)
	for child in item_option_container.get_children():
		child.queue_free()
	description.text = ""
	
func close_inventory():
	for child in item_option_container.get_children():
		child.queue_free()
		description.text = ""
		

