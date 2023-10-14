extends Node2D


@onready var interaction_area = $InteractionArea
@export var door_locked = false
@export var door_id = "dining_to_clown_hallway"
@export var key_item_id = ""

const dialogue_resource = preload("res://Dialogues/Doorway_dialogues.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	Game.door_unlocked.connect(_on_door_unlocked)
	if(Game.state_dictionary.has(door_id)):
		door_locked = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interact():
	print("Entered doorway _on_interact()")
	if(!door_locked):
		print("interact_data: " + str(interaction_area.interact_data))
		Game.door_entered_succesful.emit("res://Levels/" + interaction_area.interact_value + ".tscn", interaction_area.interact_data)
	else:
		# Call check player inventory for key_item
		if Game.player.inventory_data.item_in_inventory(key_item_id):
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "door_is_locked_with_item")
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, "door_is_locked_with_no_item")
	interaction_area.can_interact = true

func _on_door_unlocked():
	print("Unlocked Door: Entering Door _on_door_unlocked")
	door_locked = false
	Game.state_dictionary[door_id] = "unlocked"
	Game.door_entered_succesful.emit("res://Levels/" + interaction_area.interact_value + ".tscn")
