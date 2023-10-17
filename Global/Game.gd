extends Node

var player
func _ready():
	print("Saved Game")
	player = get_tree().get_first_node_in_group("Player")
	#player.inventory_data
	Utils.saveGame()

var playerHP = 10 # this needs to be loaded from the live player somehow
var playerAmmo = 0



var current_scene = null

var player_can_move = false

signal item_pick_up_attempted(slot_data: SlotData)
signal item_successfully_picked_up(slot_data: SlotData)
signal door_entered_succesful(next_scene: String, new_player_position: Vector2)
signal door_unlocked(unlocked: bool)



var item_interacted_with: SlotData = null

var item_pick_up_accepted = false:
	set (value):
		if(value == true):
			item_pick_up_attempted.emit(item_interacted_with)
			print("item_picked_up in Game")
		else:
			item_interacted_with = null
			item_pick_up_attempted.emit(item_interacted_with)
var door_unlock_accepted = false:
	set (value):
		if (value == true):
			door_unlock_accepted = true
			door_unlocked.emit(true)
			print("door unlocked (GAME)")
		else:
			door_unlock_accepted = false
			door_unlocked.emit(false)

var state_dictionary = {
	"has_gun": false,
	"has_music_sheet": false
}
# World Loading variables
@onready var last_world_position = Vector2(0, 0)
var collected_items = {}
