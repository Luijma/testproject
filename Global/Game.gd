extends Node


func _ready():
	print("Saved Game")
	Utils.saveGame()

var playerHP = 10 # this needs to be loaded from the live player somehow
var playerAmmo = 0

var player_can_move = false

signal item_pick_up_attempted(slot_data: SlotData)
signal item_successfully_picked_up(slot_data: SlotData)

var item_interacted_with: SlotData = null

var item_pick_up_accepted = false:
	set (value):
		if(value == true):
			item_pick_up_attempted.emit(item_interacted_with)
			print("item_picked_up in Game")
var state_dictionary = {
	"has_gun": false,
	"has_music_sheet": false
}
