extends Node2D
class_name OverworldItem

@export var slot_data: SlotData
@onready var interaction_area = $InteractionArea
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
#signal item_picked_up(slot_data: SlotData)
signal item_interacted(overworld_item: OverworldItem)

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	Game.item_successfully_picked_up.connect(_on_item_succesfully_picked_up)
	
func _on_interact():
	print("interaction with item ocurred")
	Game.item_interacted_with = slot_data
	if (dialogue_resource):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	print("out of dialogue_resource if")
	interaction_area.can_interact = true
	#item_interacted.emit(self)	


func _on_item_succesfully_picked_up(item_data):
	self.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
