extends Node
class_name main_game

signal toggle_game_paused(is_paused: bool)

@export var dialogue_resource: DialogueResource
@export var item_dialogues: DialogueResource

@onready var player = $Player2d/Player

@onready var inventory_interface = $UI/InventoryInterface
@onready var bullet_manager = $BulletManager
@onready var enemy_manager = $EnemyManager
@onready var world = $World

const no_item = preload("res://Item/items/no_item.tres")
const overworld_item = preload("res://Item/overworld_items/overworld_item.tscn")
const dropped_item_texture = preload("res://icon.svg")
const Slot = preload("res://inventory/slot.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.item_was_equiped.connect(_equip_player_item)
	inventory_interface.item_was_equiped.connect(player._item_equiped)
	inventory_interface.item_was_discarded.connect(player.inventory_data.remove_item)
	inventory_interface.item_was_discarded.connect(_on_item_discarded)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	# BULLET CODES
	#player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	player.player_fired_bullet.connect(bullet_manager.handle_bullet_spawned)
	# BULLET CODES
	Utils.saveGame()
	Utils.loadGame()
	
	# Global Singals
	Game.item_pick_up_attempted.connect(_on_overworld_item_picked_up)
	
	# Dialogue Cutscene Test
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "start")

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Input.set_custom_mouse_cursor(null)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func _process(delta):
	if Input.is_action_just_pressed("inventory") and Game.player_can_move:
		player.aiming_gun = false
		print("")
		toggle_inventory_interface()
		get_tree().paused = not get_tree().paused
		if(!get_tree().paused):
			inventory_interface.close_inventory()
		
func _equip_player_item(item: ItemData):
	if item != null:
		player.equiped_weapon = item
		print("Equipped item: " + item.name)
	else:
		player.equiped_weapon = no_item
	

func _on_enemy_enemy_shot_by_bullet(enemy):
	enemy.health += player.equiped_weapon.hp_value

func _on_overworld_item_item_interacted(overworld_item):
	# Here the dialogue box for Picking up Items should happen
	# On Item Pickup, item_data.item_picked_up.emit()
	print("_on_overworld_item_item_interacted called")
	if player.inventory_data.add_item(overworld_item.slot_data):
		pass#overworld_item.item_picked_up.emit(overworld_item.slot_data)


func _on_overworld_item_picked_up(slot_data):
	print("_on_overworld_item_picked_up called")
	if !player.inventory_data.add_item(slot_data):
		DialogueManager.show_example_dialogue_balloon(item_dialogues, "no_space_for_item")
	else:
		pass #Game.item_successfully_picked_up.emit(slot_data)

func _on_item_discarded(index: int, slot_data: SlotData):
	print("_on_item_discarded")
	var item = overworld_item.instantiate()
	item.slot_data = Slot.instantiate()
	item.slot_data = slot_data
	item.slot_data.item_data = slot_data.item_data
	item.slot_data.item_data.item_id = item.slot_data.item_data.name
	item.slot_data.item_data.item_id += "_dropped"
	print(item.slot_data.item_data.item_id)
	world.get_child(0).add_child(item)
	item.position = player.position
	item.sprite_2d.texture = dropped_item_texture
	print("item should now exist")
