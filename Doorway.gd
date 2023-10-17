extends Node2D


@onready var interaction_area = $InteractionArea
@export var door_locked = false
@export var door_id = "dining_to_clown_hallway"
@export var key_item_id = ""
@export var event_required = false
@export var event_experienced = false
@export var event_id = ""

signal doorway_unlocked

const dialogue_resource = preload("res://Dialogues/Doorway_dialogues.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	#Game.door_unlocked.connect(_on_door_unlocked)
	if(Game.state_dictionary.has(door_id) and event_required == false):
		door_locked = false
	elif event_required == true:
		if Game.state_dictionary.has(event_id):
			event_experienced = true
			door_locked = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interact():
	print("Entered doorway _on_interact()")
	if(!door_locked) and event_required == false:
		print("interact_data: " + str(interaction_area.interact_data))
		Game.door_entered_succesful.emit("res://Levels/" + interaction_area.interact_value + ".tscn", interaction_area.interact_data)
	elif (!door_locked) and event_required == true and event_experienced == true:
		print("Criteria met for opening door: Event experienced when required")
		Game.door_entered_succesful.emit("res://Levels/" + interaction_area.interact_value + ".tscn", interaction_area.interact_data)
	elif(!door_locked) and event_required == true and event_experienced == false:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, event_id)
	else:
		# Call check player inventory for key_item
		if Game.player.inventory_data.item_in_inventory(key_item_id):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "door_is_locked_with_item")
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "door_is_locked_with_no_item")
		await Game.door_unlocked
		if(Game.door_unlock_accepted):
			print("door should unlock")
			print(str(Game.door_unlock_accepted))
			_on_door_unlocked()
		else:
			print("door not unlocked")
			print(str(Game.door_unlock_accepted))
	interaction_area.can_interact = true

func _on_door_unlocked():
	print("Unlocked Door: Entering Door _on_door_unlocked")
	door_locked = false
	print(str(door_locked))
	Game.state_dictionary[door_id] = "unlocked"
	print(str(Game.state_dictionary.keys()))
	Game.door_entered_succesful.emit("res://Levels/" + interaction_area.interact_value + ".tscn")
