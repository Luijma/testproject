extends Node2D


@export var interact_id = ""
@export var dialogue_resource: DialogueResource = preload("res://Dialogues/Event_Dialogues.dialogue")
@export var dialogue_start: String = ""
@onready var interaction_area = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready():
		interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	Game.state_dictionary[interact_id] = "event_experienced"
