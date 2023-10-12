extends Area2D
class_name Interactable

@export var interact_label = "none"
@export var interact_type =  "none"
@export var interact_value = "none"
@export var can_interact = true

var interact: Callable = func():
	print("DEFAULT INTERACT FUNCTION CALLED")
	can_interact = true
