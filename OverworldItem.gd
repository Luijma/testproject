extends Node2D
class_name OverworldItem

@export var slot_data: SlotData
@onready var interaction_area = $InteractionArea
@export var dialogue_resource: DialogueResource = preload("res://Dialogues/item_dialogues.dialogue")
@export var dialogue_start: String = "pick_up_item_y_n"
@export var item_id: String = ""
@onready var sprite_2d = $Sprite2D
#signal item_picked_up(slot_data: SlotData)
signal item_interacted(overworld_item: OverworldItem)

signal picked_up_item(overworld_item: OverworldItem)

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	if Game.collected_items.has(item_id):
		#if(not "_dropped" in item_id):
		#	print("_dropped detected. avoiding self destruct")
		#else:
		#	print("_dropped not detected. entering self destruct")
		self.queue_free()

	
func _on_interact():
	print("interaction with item ocurred")
	Game.item_interacted_with = slot_data
	if (dialogue_resource):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		print("Awaiting signal game_pick_up_attempted")
		await Game.item_pick_up_attempted
		if(Game.item_interacted_with):
			print("Accepted item")
			_on_item_succesfully_picked_up(slot_data)
		else:
			print("Entered else for item denied")
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interaction_area.can_interact = true
	#item_interacted.emit(self)	


func _on_item_succesfully_picked_up(slot_data):
	self.queue_free()
	Game.collected_items[item_id] = "picked_up"
	print("collected items item id added: " + str(Game.collected_items.keys()))
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
