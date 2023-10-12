extends Node


signal toggle_game_paused(is_paused: bool)

@onready var player: CharacterBody2D = $Player2d/Player
@onready var inventory_interface:Control = $UI/InventoryInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	Utils.saveGame()
	Utils.loadGame()

func toggle_inventory_interface() -> void:	
	inventory_interface.visible = not inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	
